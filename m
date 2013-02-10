Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3BJXuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 18:50:37 -0500
Received: from etezian.org ([198.101.225.253]:41075 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab3BJXuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 18:50:35 -0500
Date: Mon, 11 Feb 2013 00:51:25 +0100
From: Andi Shyti <andi@etezian.org>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Cc: andi@etezian.org, tomi.valkeinen@ti.com, FlorianSchandinat@gmx.de,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 1/1] OMAP4: DSS: Add panel for Blaze Tablet boards
Message-ID: <20130210235125.GA8098@jack.whiskey>
References: <1360338220-12753-1-git-send-email-ruslan.bilovol@ti.com>
 <1360338220-12753-2-git-send-email-ruslan.bilovol@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360338220-12753-2-git-send-email-ruslan.bilovol@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ruslan,

> TC358765 is DSI-to-LVDS transmitter from Toshiba, used in
> OMAP44XX Blaze Tablet and Blaze Tablet2 boards.

I think it's fine, just some nitpicks and checkpatch warnings

> +struct {
> +	struct device *dev;
> +	struct dentry *dir;
> +} tc358765_debug;

Should this be static?

> +struct tc358765_reg {
> +	const char *name;
> +	u16 reg;
> +	u8 perm:2;
> +} tc358765_regs[] = {

Should this be static as well?

> +	{ "D1S_ZERO", D1S_ZERO, A_RW },
> +	{ "D2S_ZERO", D2S_ZERO, A_RW  },
> +	{ "D3S_ZERO", D3S_ZERO, A_RW },
> +	{ "PPI_CLRFLG", PPI_CLRFLG, A_RW },
> +	{ "PPI_CLRSIPO", PPI_CLRSIPO, A_RW },
> +	{ "PPI_HSTimeout", PPI_HSTimeout, A_RW },

WARNING: Avoid CamelCase: <PPI_HSTimeout>
#136: FILE: video/omap2/displays/panel-tc358765.c:136:
+	{ "PPI_HSTimeout", PPI_HSTimeout, A_RW },

> +	{ "PPI_HSTimeoutEnable", PPI_HSTimeoutEnable, A_RW },

WARNING: Avoid CamelCase: <PPI_HSTimeoutEnable>
#137: FILE: video/omap2/displays/panel-tc358765.c:137:
+	{ "PPI_HSTimeoutEnable", PPI_HSTimeoutEnable, A_RW },


> +static int tc358765_read_block(u16 reg, u8 *data, int len)
> +{
> +	unsigned char wb[2];
> +	struct i2c_msg msg[2];
> +	int r;
> +	mutex_lock(&tc358765_i2c->xfer_lock);
> +	wb[0] = (reg & 0xff00) >> 8;
> +	wb[1] = reg & 0xff;
> +	msg[0].addr = tc358765_i2c->client->addr;
> +	msg[0].len = 2;
> +	msg[0].flags = 0;
> +	msg[0].buf = wb;
> +	msg[1].addr = tc358765_i2c->client->addr;
> +	msg[1].flags = I2C_M_RD;
> +	msg[1].len = len;
> +	msg[1].buf = data;
> +
> +	r = i2c_transfer(tc358765_i2c->client->adapter, msg, ARRAY_SIZE(msg));
> +	mutex_unlock(&tc358765_i2c->xfer_lock);
> +
> +	if (r == ARRAY_SIZE(msg))
> +		return len;
> +
> +	return r;

If you like, here you could do

	return (r == ARRAY_SIZE(msg)) ? len : r;

Usually I like more this notation because keeps the code more
compact and immediate to read, but you don't have to

> +	mutex_lock(&tc358765_i2c->xfer_lock);
> +	ret = i2c_transfer(tc358765_i2c->client->adapter, &msg, 1);
> +	mutex_unlock(&tc358765_i2c->xfer_lock);
> +
> +	if (ret != 1)
> +		return ret;
> +	return 0;

Also here you could do

	return (ret != 1) ? ret : 0;

But this is more taste :)

> +static ssize_t tc358765_seq_write(struct file *filp, const char __user *ubuf,
> +						size_t size, loff_t *ppos)
> +{
> +	struct device *dev = tc358765_debug.dev;
> +	unsigned i, reg_count;
> +	u32 value = 0;
> +	int error = 0;
> +	/* kids, don't use register names that long */

I won't, promised, but please, drop this comment :)

> +	char name[30];
> +	char buf[50];
> +
> +	if (size >= sizeof(buf))
> +		size = sizeof(buf);

what's the point of this?

> +static void tc358765_uninitialize_debugfs(void)
> +{
> +	if (tc358765_debug.dir)
> +		debugfs_remove_recursive(tc358765_debug.dir);

WARNING: debugfs_remove_recursive(NULL) is safe this check is probably not required
#435: FILE: video/omap2/displays/panel-tc358765.c:435:
+	if (tc358765_debug.dir)
+		debugfs_remove_recursive(tc358765_debug.dir);


> +static struct tc358765_board_data *get_board_data(struct omap_dss_device
> +								*dssdev)
> +{
> +	return (struct tc358765_board_data *)dssdev->data;

You shouldn't need for this cast, does it complain?

> +}
> +
> +static void tc358765_get_timings(struct omap_dss_device *dssdev,
> +		struct omap_video_timings *timings)
> +{
> +	*timings = dssdev->panel.timings;
> +}
> +
> +static void tc358765_set_timings(struct omap_dss_device *dssdev,
> +		struct omap_video_timings *timings)
> +{
> +	dev_info(&dssdev->dev, "set_timings() not implemented\n");

... then drop the function :)

> +	if ((pins[2] & 1) || (pins[3] & 1)) {
> +		lanes |= (1 << 1);
> +		ret |= tc358765_write_register(dssdev, PPI_D0S_CLRSIPOCOUNT,
> +							board_data->clrsipo);
> +	}
> +	if ((pins[4] & 1) || (pins[5] & 1)) {
> +		lanes |= (1 << 2);
> +		ret |= tc358765_write_register(dssdev, PPI_D1S_CLRSIPOCOUNT,
> +							board_data->clrsipo);
> +	}
> +	if ((pins[6] & 1) || (pins[7] & 1)) {
> +		lanes |= (1 << 3);
> +		ret |= tc358765_write_register(dssdev, PPI_D2S_CLRSIPOCOUNT,
> +							board_data->clrsipo);
> +	}
> +	if ((pins[8] & 1) || (pins[9] & 1)) {
> +		lanes |= (1 << 4);
> +		ret |= tc358765_write_register(dssdev, PPI_D3S_CLRSIPOCOUNT,
> +							board_data->clrsipo);
> +	}

Can't this be done in one single multiwrighting command since
this registers are consecutive?

You build once the array to write and you send it at once.

Moreover it would be nice to have a name for all those nombers

> +	ret |= tc358765_write_register(dssdev, HTIM1,
> +		(tc358765_timings.hbp << 16) | tc358765_timings.hsw);
> +	ret |= tc358765_write_register(dssdev, HTIM2,
> +		((tc358765_timings.hfp << 16) | tc358765_timings.x_res));
> +	ret |= tc358765_write_register(dssdev, VTIM1,
> +		((tc358765_timings.vbp << 16) |	tc358765_timings.vsw));
> +	ret |= tc358765_write_register(dssdev, VTIM2,
> +		((tc358765_timings.vfp << 16) |	tc358765_timings.y_res));

also this and all the other cases I haven't checked

> +static int tc358765_enable(struct omap_dss_device *dssdev)
> +{
> +	struct tc358765_data *d2d = dev_get_drvdata(&dssdev->dev);
> +	int r = 0;

this initialisation is useless

> +	if (r) {
> +		dev_dbg(&dssdev->dev, "enable failed\n");

Here you could choose a different print level, I would have used
dev_err instead.

> +static int tc358765_i2c_probe(struct i2c_client *client,
> +				   const struct i2c_device_id *id)
> +{
> +	tc358765_i2c = devm_kzalloc(&client->dev, sizeof(*tc358765_i2c), GFP_KERNEL);

WARNING: line over 80 characters
#927: FILE: video/omap2/displays/panel-tc358765.c:927:
+	tc358765_i2c = devm_kzalloc(&client->dev, sizeof(*tc358765_i2c), GFP_KERNEL);


> +	/* store i2c_client pointer on private data structure */
> +	tc358765_i2c->client = client;
> +
> +	/* store private data structure pointer on i2c_client structure */
> +	i2c_set_clientdata(client, tc358765_i2c);
> +
> +	/* init mutex */
> +	mutex_init(&tc358765_i2c->xfer_lock);
> +	dev_err(&client->dev, "D2L i2c initialized\n");

while here dev_dbg (or dev_info) are better.

> +static int __init tc358765_init(void)
> +{
> +	int r;
> +	tc358765_i2c = NULL;
> +	r = i2c_add_driver(&tc358765_i2c_driver);
> +	if (r < 0) {
> +		printk(KERN_WARNING "d2l i2c driver registration failed\n");

WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ...  then pr_warn(...  to printk(KERN_WARNING ...
#981: FILE: video/omap2/displays/panel-tc358765.c:981:
+		printk(KERN_WARNING "d2l i2c driver registration failed\n");


Andi
