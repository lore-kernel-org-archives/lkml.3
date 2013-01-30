Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab3A3Nfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:35:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908Ab3A3Nfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:35:53 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Kurachkin Michail <Michail.Kurachkin@promwad.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>
Subject: Re: TDM bus support in Linux Kernel [PATCH]
Date: Wed, 30 Jan 2013 14:35:58 +0100
Message-ID: <1946596.5ULpFZ487d@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <F7F628C32E67B04DAECC5CA53521253E5FAB15CE@sv-exmb01-lo1.promwad.corp>
References: <F7F628C32E67B04DAECC5CA53521253E5FAB15CE@sv-exmb01-lo1.promwad.corp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2013 12:37:25 Kurachkin Michail wrote:
> Hi Greg,
> 
> I followed your recommendations and created a diff using Linux 3.8-rc5 sources. Please review it and give your comments.

Part #4

+/**
+ * add to list slic character device.
+ * @param dev - character device
+ * @param type - type of character device
+ * @return 0 - ok
+ */
+static int add_slic_chr_dev(struct device *dev, enum chr_dev_type type)
+{
+	struct slic_chr_dev *chr_dev;
+
+	chr_dev = kzalloc(sizeof(*chr_dev), GFP_KERNEL);
+	if (!chr_dev)
+		return -ENOMEM;
+
+	chr_dev->dev = dev;
+	chr_dev->type = type;

Here we have a memory reordering bug. Once you put
this on the list, other CPUs can see it. Yet you have not
made sure that the fields initialised before have been
flushed to RAM.

+	list_add(&chr_dev->list, &slic_chr_dev_list);
+
+	return 0;
+}

+/**
+ * Init slic driver
+ * @return 0 - ok
+ */
+static int init_slic_drv(struct si3226x_slic *slic)
+{
+	struct platform_device *pdev = slic->pdev;
+	struct si3226x_platform_data *plat = 	pdev->dev.platform_data;
+	struct si3226x_line *line = slic->lines;
+	struct device *chr_dev;
+	int rc;
+	int i;
+
+	dev_info(&pdev->dev, "run Initialization slic driver\n");
+
+	/* set default companding_mode for all lines */
+	for (i = 0; i < SI3226X_MAX_CHANNELS; i++, line++)
+		line->companding_mode = plat->companding_mode;
+
+	/* request reset GPIO */
+	rc = gpio_request(slic->reset_gpio, DRIVER_NAME "_reset");
+	if (rc < 0) {
+		dev_err(&pdev->dev, "failed to request " DRIVER_NAME "_reset\n");
+		goto out0;
+	}
+	gpio_direction_output(slic->reset_gpio, 1);
+
+	/* request interrupt GPIO */
+	rc = gpio_request(slic->int_gpio, DRIVER_NAME "_irq");
+	if (rc < 0) {
+		dev_err(&pdev->dev, "failed to request " DRIVER_NAME "_irq\n");
+		goto out1;
+	}
+	gpio_direction_input(slic->int_gpio);
+
+	dev_info(&pdev->dev, "GPIO requested\n");
+
+	slic->irq = gpio_to_irq(slic->int_gpio);
+
+	dev_info(&pdev->dev, "slic->int_gpio = %d\n", slic->int_gpio);
+	dev_info(&pdev->dev, "slic->irq = %d\n", slic->irq);
+
+	INIT_WORK(&slic->irq_work, slic_irq_callback);
+
+#ifdef CONFIG_SI3226X_POLLING
+	INIT_DELAYED_WORK(&slic->delayed_work, slic_delayed_work);
+#endif
+
+
+	/* register slic character device */
+	rc = register_chrdev(SI3226X_MAJOR, DRIVER_NAME, &slic_cnt_ops);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "can not register character device\n");
+		goto out2;
+	}

This is a race condition. You register a device before you are
finished initialising it properly.

+	/* added class device and create /dev/si3226x_cnt.X */
+	slic->devt = MKDEV(SI3226X_MAJOR, pdev->id);
+	chr_dev = device_create(slic_class, &pdev->dev, slic->devt,
+	                        slic, DRIVER_NAME "_cnt.%d", pdev->id);
+
+	if (IS_ERR(chr_dev)) {
+		dev_err(&pdev->dev, "can not added class device\n");
+		goto out3;
+	}
+
+	/*  added character device into device list
+	    for use in file operations
+	*/
+	rc = add_slic_chr_dev(chr_dev, SLIC_CHR_DEV);
+	if (rc) {
+		dev_err(&pdev->dev, "can not added character device\n");
+		goto out4;
+	}
+
+	line = slic->lines;
+	for (i = 0; i < SI3226X_MAX_CHANNELS; i++, line++) {
+		if (plat->fxs_tdm_ch[i] < 0) {
+			line->state = SI_LINE_DISABLE;
+			continue;
+		}
+
+		INIT_WORK(&line->line_call_work, do_line_call);
+
+		line->state = SI_LINE_SILENCE;
+
+		/* added class device and create /dev/si3226x_fxsX.X */
+		line->devt = MKDEV(SI3226X_MAJOR, pdev->id + 1 + i);
+		chr_dev = device_create(slic_class, &pdev->dev, line->devt,
+		                        line, DRIVER_NAME "_fxs%d.%d", i, pdev->id);
+
+		if (IS_ERR(chr_dev)) {
+			dev_err(&pdev->dev, "can not added class device\n");
+			goto out4;
+		}
+
+		/*  added created character device into device list
+		    for use in file operations
+		*/
+		rc = add_slic_chr_dev(chr_dev, LINE_CHR_DEV);
+		if (rc) {
+			dev_err(&pdev->dev, "can't added character device\n");
+			goto out4;
+		}
+	}
+
+	rc = init_slic(slic);
+	if (rc) {
+		dev_err(&pdev->dev, "slic initialization fail\n");
+		goto out4;
+	}
+
+#ifdef CONFIG_SI3226X_POLLING
+	dev_info(&pdev->dev, "schedule delayed work\n");
+	schedule_delayed_work(&slic->delayed_work, MSEC(50));
+#else
+	dev_info(&pdev->dev, "request irq\n");
+
+	/* set interrupt callback slic_irq */
+	rc = request_irq(slic->irq, slic_irq,
+	                 IRQF_TRIGGER_FALLING | IRQF_DISABLED,
+	                 dev_name(&slic->pdev->dev), slic);
+
+	if (rc) {
+		dev_err(&pdev->dev, "can not request IRQ\n");
+		rc = -EINVAL;
+		goto out5;
+	}
+#endif
+
+	dev_info(&pdev->dev, "success initialization slic driver\n");
+	return 0;
+
+out5:
+	free_irq(slic->irq, slic);
+	deinit_slic(slic);
+
+out4:
+	{
+		/* remove all character devices */
+		struct slic_chr_dev *chr_dev, *chr_dev_tmp;
+		list_for_each_entry_safe(chr_dev, chr_dev_tmp,
+		                         &slic_chr_dev_list, list) {
+			device_del(chr_dev->dev);
+			del_slic_chr_dev(chr_dev->dev);
+		}
+	}
+
+out3:
+	unregister_chrdev(SI3226X_MAJOR, DRIVER_NAME);
+
+out2:
+	gpio_free(slic->int_gpio);
+
+out1:
+	gpio_free(slic->reset_gpio);
+
+out0:
+	return rc;
+}

+/**
+ * allocate memory and configure slic descriptor.
+ * @param pdev - platform device
+ * @return allocated slic controller descriptor
+ */
+struct si3226x_slic *alloc_slic(struct platform_device *pdev) {
+	int i;
+	struct si3226x_slic 	*slic;
+	struct si3226x_line *line;
+
+	slic = kzalloc(sizeof *slic, GFP_KERNEL);
+	if (!slic)
+		return NULL;
+
+	memset(slic, 0, sizeof *slic);

kzalloc and memset is overkill

+	platform_set_drvdata(pdev, slic);
+
+	slic->pdev = pdev;
+
+	line = slic->lines;
+	for (i = 0; i < SI3226X_MAX_CHANNELS; i++, line++) {
+		line->ch = i;
+		line->audio_start_flag = 0;
+	}
+
+	return slic;
+}
+
