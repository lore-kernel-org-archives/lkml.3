Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab3GQNrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:47:23 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46407 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab3GQNrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:47:19 -0400
Message-ID: <51E6A015.8040705@ti.com>
Date: Wed, 17 Jul 2013 16:45:57 +0300
From: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "tony@atomide.com" <tony@atomide.com>,
        "benoit.cousson@linaro.org" <benoit.cousson@linaro.org>,
        "Nayak, Rajendra" <rnayak@ti.com>,
        "Ujfalusi, Peter" <peter.ujfalusi@ti.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "ch.naveen@samsung.com" <ch.naveen@samsung.com>,
        "poeschel@lemonage.de" <poeschel@lemonage.de>,
        "Kim, Milo" <Milo.Kim@ti.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver
References: <1373613482-28390-1-git-send-email-oleksandr.kozaruk@ti.com> <1373613482-28390-3-git-send-email-oleksandr.kozaruk@ti.com>,<51E05F6C.1060506@metafoo.de> <2A7ABDFCE21540479A5AEB0244A684D5E3D067@DNCE04.ent.ti.com> <51E3DE21.9060105@metafoo.de>
In-Reply-To: <51E3DE21.9060105@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.74]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 01:33:53PM +0200, Lars-Peter Clausen wrote:
 > On 07/15/2013 01:09 PM, Kozaruk, Oleksandr wrote:
 > [...]
 > >
 > >>> +     ret = devm_request_threaded_irq(dev, irq, NULL,
 > >>> + twl6030_gpadc_irq_handler,
 > >>> + IRQF_ONESHOT, "twl6030_gpadc", gpadc);
 > >>
 > >> You access memory in the interrupt handler which is freed before 
the interrupt
 > >> handler is freed.
 > > Thanks for pointing this. devm_* will free memory for irq after the 
driver
 > > is removed and memory for the device is freed. I took me awhile to 
understand
 > > this. Is there going to be something like devm_iio_device_alloc? 
whould it be helpfull?
 > >
 >
 > Yes, I think it certainly makes sense to add a 
devm_iio_device_alloc(), care
 > to send a patch?

Anything like this? (of course it's not a patch)

struct iio_dev *devm_iio_device_alloc(struct device *dev, int sizeof_priv)
{
     struct iio_dev *indio_dev;
     size_t alloc_size;

     alloc_size = sizeof(struct iio_dev);
     if (sizeof_priv) {
         alloc_size = ALIGN(alloc_size, IIO_ALIGN);
         alloc_size += sizeof_priv;
     }
     /* ensure 32-byte alignment of whole construct ? */
     alloc_size += IIO_ALIGN - 1;

     indio_dev = devm_kzalloc(dev, alloc_size, GFP_KERNEL);
     if (indio_dev) {
         indio_dev->dev.groups = indio_dev->groups;
         indio_dev->dev.type = &iio_device_type;
         indio_dev->dev.bus = &iio_bus_type;
         device_initialize(&indio_dev->dev);
         dev_set_drvdata(&indio_dev->dev, (void *)indio_dev);
         mutex_init(&indio_dev->mlock);
         mutex_init(&indio_dev->info_exist_lock);
         INIT_LIST_HEAD(&indio_dev->channel_attr_list);

         indio_dev->id = ida_simple_get(&iio_ida, 0, 0, GFP_KERNEL);
         if (indio_dev->id < 0) {
             /* cannot use a dev_err as the name isn't available */
             printk(KERN_ERR "Failed to get id\n");
             kfree(dev);
             return NULL;
         }
         dev_set_name(&indio_dev->dev, "iio:device%d", indio_dev->id);
         INIT_LIST_HEAD(&indio_dev->buffer_list);
     }

     return indio_dev;
}
EXPORT_SYMBOL(devm_iio_device_alloc);

Regards,
OK
