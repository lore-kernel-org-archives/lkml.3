Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaAUTBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:01:25 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:36401 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaAUTBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:01:20 -0500
Message-ID: <52DEC3FD.2040701@linux.com>
Date: Tue, 21 Jan 2014 20:01:17 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH V3 1/1] Drivers: hv: Implement the file copy service
References: <1390331164-14292-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1390331164-14292-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/21/2014 08:06 PM, K. Y. Srinivasan wrote:
> Implement the file copy service for Linux guests on Hyper-V. This permits the
> host to copy a file (over VMBUS) into the guest. This facility is part of
> "guest integration services" supported on the Windows platform.
> Here is a link that provides additional details on this functionality:
> 
> http://technet.microsoft.com/en-us/library/dn464282.aspx
> 
> In V1 version of the patch I have addressed comments from
> Olaf Hering <olaf@aepfle.de> and Dan Carpenter <dan.carpenter@oracle.com>
> 
> In V2 version of this patch I did some minor cleanup (making some globals
> static). In this version of the patch I have addressed all of Olaf's
> most recent set of comments/concerns.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---

Just a few comments.

> +	/*
> +	 * The  strings sent from the host are encoded in
> +	 * in utf16; convert it to utf8 strings.
> +	 * The host assures us that the utf16 strings will not exceed
> +	 * the max lengths specified. We will however, reserve room
> +	 * for the string terminating character - in the utf16s_utf8s()
> +	 * function we limit the size of the buffer where the converted
> +	 * string is placed to W_MAX_PATH -1 to gaurantee

	s/gaurantee/guarantee

> +	 * that the strings can be properly terminated!
> +	 */
> +
> +	switch (operation) {
> +	case START_FILE_COPY:
> +		memset(smsg_out, 0, sizeof(struct hv_start_fcopy));
> +		smsg_out->hdr.operation = operation;
> +		smsg_in = (struct hv_start_fcopy *)fcopy_transaction.fcopy_msg;
> +
> +		utf16s_to_utf8s((wchar_t *)smsg_in->file_name, W_MAX_PATH,
> +				UTF16_LITTLE_ENDIAN,
> +				(__u8 *)smsg_out->file_name, W_MAX_PATH - 1);
> +
> +		utf16s_to_utf8s((wchar_t *)smsg_in->path_name, W_MAX_PATH,
> +				UTF16_LITTLE_ENDIAN,
> +				(__u8 *)smsg_out->path_name, W_MAX_PATH - 1);
> +
> +		smsg_out->copy_flags = smsg_in->copy_flags;
> +		smsg_out->file_size = smsg_in->file_size;
> +		break;
> +
> +	default:
> +		break;
> +	}
> +	up(&fcopy_transaction.read_sema);
> +	return;
> +}
> +
> [...]
> +static ssize_t fcopy_read(struct file *file, char __user *buf,
> +		size_t count, loff_t *ppos)
> +{
> +	int ret;
> +	void *src;
> +	size_t copy_size;
> +	int operation;
> +
> +	/*
> +	 * Wait until there is something to be read.
> +	 */
> +	ret = down_interruptible(&fcopy_transaction.read_sema);
> +	if (ret)
> +		return -EINTR;

I don't know, but since you use 'ret' only once and you don't
even read it after, you could just simply remove it and check
the return code of down_interruptible() directly
> +
> +	operation = fcopy_transaction.fcopy_msg->operation;
> +
> +	if (operation == START_FILE_COPY) {
> +		src = &fcopy_transaction.message;
> +		copy_size = sizeof(struct hv_start_fcopy);
> +		if (count < copy_size)
> +			return 0;
> +	} else {
> +		src = fcopy_transaction.fcopy_msg;
> +		copy_size = sizeof(struct hv_do_fcopy);
> +		if (count < copy_size)
> +			return 0;
> +	}
> +	if (copy_to_user(buf, src, copy_size))
> +		return -EFAULT;

...like you do here.

-- 
Regards,
Levente Kurusa
