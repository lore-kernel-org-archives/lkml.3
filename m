Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935483Ab3FTBWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 21:22:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39029 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934734Ab3FTBWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 21:22:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130620110610.7d245d88b70620fa271a29f7@canb.auug.org.au>
References: <20130619153225.9ff68f0984bfa54333c4df10@canb.auug.org.au>
	<CACVXFVMhVs7Wy1A=TfczYzHLFwyRPhEGW9Yo9hTERekaxSnpdQ@mail.gmail.com>
	<20130619143918.GC8413@kroah.com>
	<CACVXFVObBDwaounzZ7RyF=+QrQCBoEd0s-uLYFokksOzKgZSjA@mail.gmail.com>
	<20130619163628.GA28672@kroah.com>
	<CACVXFVNsbBunNzYecUG34sFjPqRuzMHRTBD2Siy9d4RhqPnr3A@mail.gmail.com>
	<20130620110610.7d245d88b70620fa271a29f7@canb.auug.org.au>
Date: Thu, 20 Jun 2013 09:22:13 +0800
Message-ID: <CACVXFVN-B7ZrqjoA_QNkWKjM0XdM-S08h-d6JuRjsYOX0YPt=A@mail.gmail.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 driver-core.current tree
From: Ming Lei <ming.lei@canonical.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Thanks for your help.

On Thu, Jun 20, 2013 at 9:06 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

>
> Try "git diff-tree --cc e4b00d75ee3ed3af9fac83970d21e27d1ad4aa8d"

Greg, Stephen, so is sort of below generated patch what you expected?

If yes, I will send it out to you.

e4b00d75ee3ed3af9fac83970d21e27d1ad4aa8d
diff --cc drivers/base/firmware_class.c
index 6ede229,01e2103..7fefcb5
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@@ -452,35 -446,27 +452,52 @@@ static struct firmware_priv *to_firmwar
  	return container_of(dev, struct firmware_priv, dev);
  }

- static void fw_load_abort(struct firmware_buf *buf)
 -static void fw_load_abort(struct firmware_priv *fw_priv)
++static void __fw_load_abort(struct firmware_buf *buf)
  {
 -	struct firmware_buf *buf = fw_priv->buf;
 -
+ 	/*
+ 	 * There is a small window in which user can write to 'loading'
+ 	 * between loading done and disappearance of 'loading'
+ 	 */
+ 	if (test_bit(FW_STATUS_DONE, &buf->status))
+ 		return;
+
 +	list_del_init(&buf->pending_list);
  	set_bit(FW_STATUS_ABORT, &buf->status);
  	complete_all(&buf->completion);
 +}
 +
++static void fw_load_abort(struct firmware_priv *fw_priv)
++{
++	struct firmware_buf *buf = fw_priv->buf;
++
++	__fw_load_abort(buf);
+
+ 	/* avoid user action after loading abort */
+ 	fw_priv->buf = NULL;
+ }
+
  #define is_fw_load_aborted(buf)	\
  	test_bit(FW_STATUS_ABORT, &(buf)->status)

 +static LIST_HEAD(pending_fw_head);
 +
 +/* reboot notifier for avoid deadlock with usermode_lock */
 +static int fw_shutdown_notify(struct notifier_block *unused1,
 +			      unsigned long unused2, void *unused3)
 +{
 +	mutex_lock(&fw_lock);
 +	while (!list_empty(&pending_fw_head))
- 		fw_load_abort(list_first_entry(&pending_fw_head,
++		__fw_load_abort(list_first_entry(&pending_fw_head,
 +					       struct firmware_buf,
 +					       pending_list));
 +	mutex_unlock(&fw_lock);
 +	return NOTIFY_DONE;
 +}
 +
 +static struct notifier_block fw_shutdown_nb = {
 +	.notifier_call = fw_shutdown_notify,
 +};
 +
  static ssize_t firmware_timeout_show(struct class *class,
  				     struct class_attribute *attr,
  				     char *buf)
@@@ -911,23 -895,6 +927,23 @@@ static int fw_load_from_user_helper(str
  	fw_priv->buf = firmware->priv;
  	return _request_firmware_load(fw_priv, uevent, timeout);
  }
 +
 +#ifdef CONFIG_PM_SLEEP
 +/* kill pending requests without uevent to avoid blocking suspend */
 +static void kill_requests_without_uevent(void)
 +{
 +	struct firmware_buf *buf;
 +	struct firmware_buf *next;
 +
 +	mutex_lock(&fw_lock);
 +	list_for_each_entry_safe(buf, next, &pending_fw_head, pending_list) {
 +		if (!buf->need_uevent)
- 			 fw_load_abort(buf);
++			 __fw_load_abort(buf);
 +	}
 +	mutex_unlock(&fw_lock);
 +}
 +#endif
 +
  #else /* CONFIG_FW_LOADER_USER_HELPER */
  static inline int
  fw_load_from_user_helper(struct firmware *firmware, const char *name,


Thanks,
--
Ming Lei
