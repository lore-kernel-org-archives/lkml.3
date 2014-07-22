Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbaGVRjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 13:39:04 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:64945 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292AbaGVRjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 13:39:00 -0400
MIME-Version: 1.0
In-Reply-To: <s5htx69hohk.wl%tiwai@suse.de>
References: <1405969601-4234-1-git-send-email-keescook@chromium.org>
	<1405969601-4234-3-git-send-email-keescook@chromium.org>
	<s5htx69hohk.wl%tiwai@suse.de>
Date: Tue, 22 Jul 2014 10:39:00 -0700
X-Google-Sender-Auth: _7SM2SVtEHj06xuwDbsMKVxD7NM
Message-ID: <CAGXu5j+H4_f0FmEh9=zZnisDu-xB1dGo6c6oDOTV-=LDD1-gtw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] firmware_class: perform new LSM checks
From: Kees Cook <keescook@chromium.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 11:55 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Mon, 21 Jul 2014 12:06:41 -0700,
> Kees Cook wrote:
>>
>> This attaches LSM hooks to the existing firmware loading interfaces:
>> filesystem-found firmware and demand-loaded blobs.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  drivers/base/firmware_class.c |   16 ++++++++++++++--
>>  1 file changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
>> index d276e33880be..7399bab71ced 100644
>> --- a/drivers/base/firmware_class.c
>> +++ b/drivers/base/firmware_class.c
>> @@ -28,6 +28,7 @@
>>  #include <linux/suspend.h>
>>  #include <linux/syscore_ops.h>
>>  #include <linux/reboot.h>
>> +#include <linux/security.h>
>>
>>  #include <generated/utsrelease.h>
>>
>> @@ -308,12 +309,17 @@ static int fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf)
>>       if (rc != size) {
>>               if (rc > 0)
>>                       rc = -EIO;
>> -             vfree(buf);
>> -             return rc;
>> +             goto fail;
>>       }
>> +     rc = security_kernel_fw_from_file(file, buf, size);
>> +     if (rc)
>> +             goto fail;
>>       fw_buf->data = buf;
>>       fw_buf->size = size;
>>       return 0;
>> +fail:
>> +     vfree(buf);
>> +     return rc;
>>  }
>>
>>  static int fw_get_filesystem_firmware(struct device *device,
>> @@ -640,6 +646,12 @@ static ssize_t firmware_loading_store(struct device *dev,
>>               break;
>>       case 0:
>>               if (test_bit(FW_STATUS_LOADING, &fw_buf->status)) {
>> +                     if (security_kernel_fw_from_file(NULL, fw_buf->data,
>> +                                                      fw_buf->size)) {
>> +                             fw_load_abort(fw_priv);
>> +                             break;
>> +                     }
>>                       set_bit(FW_STATUS_DONE, &fw_buf->status);
>>                       clear_bit(FW_STATUS_LOADING, &fw_buf->status);
>
> security_kernel_fw_from_file() should be called after
> fw_map_pages_buf() call (that is found after these lines).
> Otherwise fw_buf->buf won't contain a valid buffer pointer.

Ah! Good to know. I guess I was getting lucky in my testing. Is this a
race condition?

-Kees

-- 
Kees Cook
Chrome OS Security
