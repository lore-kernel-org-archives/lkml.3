Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030671AbaGRRMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:12:05 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51179 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030585AbaGRRMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:12:02 -0400
Message-ID: <1405703514.11182.6.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 6/7] firmware_class: add "fd" input file
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>, zohar@us.ibm.com
Date: Fri, 18 Jul 2014 13:11:54 -0400
In-Reply-To: <1405373897-31671-7-git-send-email-keescook@chromium.org>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
	 <1405373897-31671-7-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071817-0928-0000-0000-000003778016
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-14 at 14:38 -0700, Kees Cook wrote: 
> As an alternative to loading bytes from the "data" blob when reading
> firmware, let kernel read from an fd, so that the LSM can reason about
> the origin of firmware contents during userspace on-demand loading.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  Documentation/firmware_class/README |   10 +++++
>  drivers/base/firmware_class.c       |   77 ++++++++++++++++++++++++++++++++++-
>  2 files changed, 86 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/firmware_class/README b/Documentation/firmware_class/README
> index 71f86859d7d8..d899bdacba1e 100644
> --- a/Documentation/firmware_class/README
> +++ b/Documentation/firmware_class/README
> @@ -59,6 +59,16 @@
>   8), kernel(driver): Driver code calls release_firmware(fw_entry) releasing
>  		 the firmware image and any related resource.
> 
> + Alternative loading (via file descriptor):
> + ==========================================
> + Instead of "loading", and "data" above, firmware can be loaded through
> + an open file descriptor as well, via the "fd" file:
> +
> + Replacing steps 2 thorugh 6 above with the following userspace actions,
> + performs the same loading:
> +	- open firmware image file (e.g. as fd 3).
> +	- write fd (e.g. "3") to /sys/class/firmware/xxx/fd.
> +
>   High level behavior (driver code):
>   ==================================
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index b38cbcd6ebb1..eac996447d28 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -839,6 +839,70 @@ static struct bin_attribute firmware_attr_data = {
>  	.write = firmware_data_write,
>  };
> 
> +/**
> + * fd_store - set value in the 'fd' control file
> + * @dev: device pointer
> + * @attr: device attribute pointer
> + * @buf: buffer to scan for loading fd value
> + * @count: number of bytes in @buf
> + *
> + * Parses an fd number from buf, and then loads firmware bytes from
> + * the current process's matching open fd.
> + *
> + **/
> +static ssize_t fd_store(struct device *dev,
> +				 struct device_attribute *attr,
> +				 const char *buf, size_t count)
> +{

I must be missing something.  Here's a static definition, where's the
call to fd_store()?

Mimi

> +	struct firmware_priv *fw_priv = to_firmware_priv(dev);
> +	struct firmware_buf *fw_buf = fw_priv->buf;
> +	ssize_t retval;
> +	int fd;
> +	struct fd f;
> +
> +	if (!capable(CAP_SYS_RAWIO))
> +		return -EPERM;
> +
> +	retval = kstrtoint(buf, 10, &fd);
> +	if (retval)
> +		return retval;
> +
> +	f = fdget(fd);
> +	if (!f.file)
> +		return -EBADF;
> +
> +	mutex_lock(&fw_lock);
> +	/* If we raced another loader, we must fail. */
> +	if (test_bit(FW_STATUS_DONE, &fw_buf->status)) {
> +		retval = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	fw_load_start(fw_buf);
> +	/* fw_read_file_contents uses vmalloc, not pages. */
> +	fw_buf->is_paged_buf = false;
> +	retval = fw_read_file_contents(f.file, fw_buf);
> +	if (retval) {
> +		/* If we called fw_load_start, we must abort on fail. */
> +		fw_load_abort(fw_priv);
> +		goto unlock;
> +	}
> +
> +	/* Success. */
> +	set_bit(FW_STATUS_DONE, &fw_buf->status);
> +	list_del_init(&fw_buf->pending_list);
> +	complete_all(&fw_buf->completion);
> +
> +unlock:
> +	mutex_unlock(&fw_lock);
> +	fdput(f);
> +
> +	if (retval)
> +		return retval;
> +	return count;
> +}
> +static DEVICE_ATTR_WO(fd);
> +
>  static void firmware_class_timeout_work(struct work_struct *work)
>  {
>  	struct firmware_priv *fw_priv = container_of(work,
> @@ -912,10 +976,19 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
>  		mutex_lock(&fw_lock);
>  		list_del_init(&buf->pending_list);
>  		mutex_unlock(&fw_lock);
> -		dev_err(f_dev, "%s: device_create_file failed\n", __func__);
> +		dev_err(f_dev, "%s: dev_attr_loading failed\n", __func__);
>  		goto err_del_bin_attr;
>  	}
> 
> +	retval = device_create_file(f_dev, &dev_attr_fd);
> +	if (retval) {
> +		mutex_lock(&fw_lock);
> +		list_del_init(&buf->pending_list);
> +		mutex_unlock(&fw_lock);
> +		dev_err(f_dev, "%s: &dev_attr_fd failed\n", __func__);
> +		goto err_del_loading;
> +	}
> +
>  	if (opt_flags & FW_OPT_UEVENT) {
>  		buf->need_uevent = true;
>  		dev_set_uevent_suppress(f_dev, false);
> @@ -933,6 +1006,8 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
>  	if (!buf->data)
>  		retval = -ENOMEM;
> 
> +	device_remove_file(f_dev, &dev_attr_fd);
> +err_del_loading:
>  	device_remove_file(f_dev, &dev_attr_loading);
>  err_del_bin_attr:
>  	device_remove_bin_file(f_dev, &firmware_attr_data);


