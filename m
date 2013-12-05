Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab3LESum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:50:42 -0500
Received: from service87.mimecast.com ([91.220.42.44]:41346 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab3LESul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:50:41 -0500
Message-ID: <52A0CB04.8030502@arm.com>
Date: Thu, 05 Dec 2013 18:50:44 +0000
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arve@android.com" <arve@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "ccross@android.com" <ccross@android.com>,
        Dave Butcher <Dave.Butcher@arm.com>,
        "irogers@google.com" <irogers@google.com>,
        "romlem@android.com" <romlem@android.com>
Subject: Re: [PATCH v1 3/9] staging: android: binder: Add cmd == CMD_NAME
 handling
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com> <1386180581-6710-4-git-send-email-serban.constantinescu@arm.com> <20131205084042.GW28413@mwanda>
In-Reply-To: <20131205084042.GW28413@mwanda>
X-OriginalArrivalTime: 05 Dec 2013 18:50:38.0393 (UTC) FILETIME=[E3A0CA90:01CEF1EA]
X-MC-Unique: 113120518503901401
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/13 08:40, Dan Carpenter wrote:
> On Wed, Dec 04, 2013 at 06:09:35PM +0000, Serban Constantinescu wrote:
>> This patch modifies the functions that need to be passed the explicit
>> command to use a boolean flag. This way we can reuse the code for 64bit
>> compat commands.
>>
>
> I don't understand this at all.  cmd seems like it should be 32 bits
> on both arches.
Command is 32bit for both arches but does not have the same value. Here 
is what happens, this patch make more sense when looking at the compat 
layer.

The binder commands differ between 32bit userspace and 64bit kernels. E.g:

> BR_INCREFS = _IOR('r', 7, struct binder_ptr_cookie)

> COMPAT_BR_INCREFS = _IOR('r', 7, struct compat_binder_ptr_cookie)

> struct compat_binder_ptr_cookie {
>     compat_uptr_t ptr;
>     compat_uptr_t cookie;
> };

> struct binder_ptr_cookie {
>     void *ptr;
>     void *cookie;
> };

(the IOR() macro encodes the size of the transaction - struct 
binder_ptr_cookie).

This enables me to use the same handler for:

* native 64bit kernel/ 64bit userspace

>           case BC_INCREFS_DONE:
>         case BC_ACQUIRE_DONE: {
>                  void __user *node_ptr;
>                  void *cookie;
>
>                  if (get_user(node_ptr, (void * __user *)ptr))
>                        return -EFAULT;
>                  ptr += sizeof(void *);
>                  if (get_user(cookie, (void * __user *)ptr))
>                        return -EFAULT;
>                  ptr += sizeof(void *);
>                  bc_increfs_done(proc, thread, cmd == BC_ACQUIRE_DONE, node_ptr, cookie);
>                  break;
>           }

* compat 64bit kernel/ 32bit userspace.

> +       case COMPAT_BC_INCREFS_DONE:
> +       case COMPAT_BC_ACQUIRE_DONE: {
> +               compat_uptr_t node_ptr;
> +               compat_uptr_t cookie;
> +
> +               if (get_user(node_ptr, (compat_uptr_t __user *)*ptr))
> +                       return -EFAULT;
> +               *ptr += sizeof(compat_uptr_t);
> +               if (get_user(cookie, (compat_uptr_t __user *)*ptr))
> +                       return -EFAULT;
> +               *ptr += sizeof(compat_uptr_t);
> +               bc_increfs_done(proc, thread, cmd == COMPAT_BC_ACQUIRE_DONE,
> +                       compat_ptr(node_ptr), compat_ptr(cookie));
> +               break;

where the prototype for bc_increfs_done() has changed to:

>  static void bc_increfs_done(struct binder_proc *proc,
> -        struct binder_thread *thread, uint32_t cmd,
> +        struct binder_thread *thread, bool acquire,

Obsucre on its own, I should add more details in the commit message.

Thanks,
Serban C

