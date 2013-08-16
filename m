Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3HPSqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:46:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3HPSqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:46:15 -0400
Date: Fri, 16 Aug 2013 11:46:14 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH RFC 1/3] spmi: Linux driver framework for SPMI
Message-ID: <20130816184614.GA31510@kroah.com>
References: <cover.1376596224.git.joshc@codeaurora.org>
 <02deef1d90121011ab1df90ad704ef0ee36e2584.1376596224.git.joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02deef1d90121011ab1df90ad704ef0ee36e2584.1376596224.git.joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 01:37:09PM -0700, Josh Cartwright wrote:
> --- /dev/null
> +++ b/drivers/of/of_spmi.c
> @@ -0,0 +1,74 @@
> +/* Copyright (c) 2012,2013 The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#define pr_fmt(fmt) "%s: " fmt, __func__

As you never make a pr_* call in this file, this line isn't needed.

> +++ b/drivers/spmi/spmi-dbgfs.c
> @@ -0,0 +1,591 @@
> +/* Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#define pr_fmt(fmt) "%s:%d: " fmt, __func__, __LINE__

__func__ and __LINE__?  Is that really needed, what will it help with?
Seems like extra noise, especially as you only have a few pr_* calls in
this file:

> +static int
> +spmi_read_data(struct spmi_device *sdev, uint8_t *buf, int offset, int cnt)
> +{
> +	int ret = 0;
> +	int len;
> +	uint16_t addr;
> +
> +	while (cnt > 0) {
> +		addr = offset & 0xFFFF;
> +		len = min(cnt, MAX_REG_PER_TRANSACTION);
> +
> +		ret = spmi_ext_register_readl(sdev, addr, buf, len);
> +		if (ret < 0) {
> +			pr_err("SPMI read failed, err = %d\n", ret);

Should be using dev_err() instead.

> +/**
> + * spmi_write_data: writes data across the SPMI bus
> + * @ctrl: The SPMI controller
> + * @buf: data to be written.
> + * @offset: SPMI address offset to start writing to.
> + * @cnt: The number of bytes to write.
> + *
> + * Returns 0 on success, otherwise returns error code from SPMI driver.
> + */
> +static int
> +spmi_write_data(struct spmi_device *sdev, uint8_t *buf, int offset, int cnt)
> +{
> +	int ret = 0;
> +	int len;
> +	uint16_t addr;
> +
> +	while (cnt > 0) {
> +		addr = offset & 0xFFFF;
> +		len = min(cnt, MAX_REG_PER_TRANSACTION);
> +
> +		ret = spmi_ext_register_writel(sdev, addr, buf, len);
> +		if (ret < 0) {
> +			pr_err("SPMI write failed, err = %d\n", ret);

Same, dev_err() please.

> +static ssize_t spmi_device_dfs_reg_write(struct file *file,
> +					 const char __user *buf,
> +					 size_t count, loff_t *ppos)
> +{
> +	int bytes_read;
> +	int data;
> +	int pos = 0;
> +	int cnt = 0;
> +	u8  *values;
> +	size_t ret = 0;
> +
> +	struct spmi_trans *trans = file->private_data;
> +	u32 offset = trans->offset;
> +
> +	/* Make a copy of the user data */
> +	char *kbuf = kmalloc(count + 1, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	ret = copy_from_user(kbuf, buf, count);
> +	if (ret == count) {
> +		pr_err("failed to copy data from user\n");

No need for a message here at all, you will get a message in the
function if something happened wrong.

Also, shouldn't it just be a simple:
	if (copy_from_user()) {
test?

> +		ret = -EFAULT;
> +		goto free_buf;
> +	}
> +
> +	count -= ret;
> +	*ppos += count;
> +	kbuf[count] = '\0';
> +
> +	/* Override the text buffer with the raw data */
> +	values = kbuf;
> +
> +	/* Parse the data in the buffer.  It should be a string of numbers */
> +	while (sscanf(kbuf + pos, "%i%n", &data, &bytes_read) == 1) {
> +		pos += bytes_read;
> +		values[cnt++] = data & 0xff;
> +	}
> +
> +	if (!cnt)
> +		goto free_buf;
> +
> +	/* Perform the SPMI write(s) */
> +	ret = spmi_write_data(trans->sdev, values, offset, cnt);
> +
> +	if (ret) {
> +		pr_err("SPMI write failed, err = %zu\n", ret);

dev_err() please.

> +static ssize_t spmi_device_dfs_reg_read(struct file *file, char __user *buf,
> +					size_t count, loff_t *ppos)
> +{
> +	struct spmi_trans *trans = file->private_data;
> +	struct spmi_log_buffer *log = trans->log;
> +	size_t ret;
> +	size_t len;
> +
> +	/* Is the the log buffer empty */
> +	if (log->rpos >= log->wpos) {
> +		if (get_log_data(trans) <= 0)
> +			return 0;
> +	}
> +
> +	len = min(count, (size_t) log->wpos - log->rpos);
> +
> +	ret = copy_to_user(buf, &log->data[log->rpos], len);
> +	if (ret == len) {
> +		pr_err("error copy SPMI register values to user\n");

Same comments as above.

> +void __exit spmi_dfs_exit(void)
> +{
> +	pr_debug("de-initializing spmi debugfs ...");

Not needed, use the in-kernel trace functionality if you really want to
know this.

> +	debugfs_remove_recursive(spmi_debug_root);
> +}
> +
> +void __init spmi_dfs_init(void)
> +{
> +	struct dentry *help;
> +
> +	pr_debug("creating SPMI debugfs file-system\n");

Same as above, not needed.

So, with those changes, pr_fmt() isn't needed at all :)

> --- /dev/null
> +++ b/drivers/spmi/spmi-dbgfs.h
> @@ -0,0 +1,37 @@
> +/* Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#ifndef _SPMI_DBGFS_H
> +#define _SPMI_DBGFS_H
> +
> +#include <linux/spmi.h>
> +#include <linux/debugfs.h>
> +
> +#ifdef CONFIG_DEBUG_FS

Why?  If debugfs isn't enabled, the functions should just compile away
with the debugfs_() calls, so no need to do this type of thing here,
right?

> +
> +extern void __init spmi_dfs_init(void);
> +extern void __exit spmi_dfs_exit(void);
> +extern void spmi_dfs_add_controller(struct spmi_controller *ctrl);
> +extern void spmi_dfs_del_controller(struct spmi_controller *ctrl);
> +extern void spmi_dfs_add_device(struct spmi_device *sdev);
> +extern void spmi_dfs_del_device(struct spmi_device *sdev);
> +
> +#else
> +
> +static inline void __init spmi_dfs_init(void) { }
> +static inline void __exit spmi_dfs_exit(void) { }
> +static inline void spmi_dfs_add_controller(struct spmi_controller *ctrl) { }
> +static inline void spmi_dfs_del_controller(struct spmi_controller *ctrl) { }
> +static inline void spmi_dfs_add_device(struct spmi_device *sdev) { }
> +static inline void spmi_dfs_del_device(struct spmi_device *sdev) { }
> +#endif
> +
> +#endif /* _SPMI_DBGFS_H */
> diff --git a/drivers/spmi/spmi.c b/drivers/spmi/spmi.c
> new file mode 100644
> index 0000000..3bbcc63
> --- /dev/null
> +++ b/drivers/spmi/spmi.c
> @@ -0,0 +1,449 @@
> +/* Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#define pr_fmt(fmt) "%s: " fmt, __func__

Again, not needed for this file, because:

> +int spmi_add_controller(struct spmi_controller *ctrl)
> +{
> +	int id;
> +
> +	pr_debug("adding controller for bus %d (0x%p)\n", ctrl->nr, ctrl);

dev_dbg() if you really need/want it.

> +
> +	if (((int)ctrl->nr) < 0) {
> +		pr_err("invalid bus identifier %d\n", ctrl->nr);

dev_err() please.

> +		return -EINVAL;
> +	}
> +
> +	idr_preload(GFP_KERNEL);
> +	mutex_lock(&board_lock);
> +	id = idr_alloc(&ctrl_idr, ctrl, ctrl->nr, ctrl->nr + 1, GFP_NOWAIT);
> +	mutex_unlock(&board_lock);
> +	idr_preload_end();
> +
> +	if (id < 0) {
> +		pr_err(
> +		   "idr_alloc(start:%d end:%d):%d at spmi_add_controller()\n",
> +		   ctrl->nr, ctrl->nr, id);

dev_err() please.

And then the pr_fmt() line can be removed.

thanks,

greg k-h
