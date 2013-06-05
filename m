Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab3FEI3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:29:04 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42365 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3FEI3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:29:00 -0400
Message-ID: <51AEF6C8.5080405@arm.com>
Date: Wed, 05 Jun 2013 09:28:56 +0100
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?windows-1252?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH v4 2/6] staging: android: binder: fix binder interface
 for 64bit compat layer
References: <1369217581-16285-1-git-send-email-serban.constantinescu@arm.com> <1369217581-16285-3-git-send-email-serban.constantinescu@arm.com> <CAMP5XgfTmNZ_N6P-EGtCD++0KCi2fmQVQFht6kg6Gs_2saMLbg@mail.gmail.com> <51ADAB5F.70902@arm.com> <CAMP5XgfyUQT+mQ+SCFhyCSzAWevXUBpTXjpAYS54YTOb-PSpOg@mail.gmail.com>
In-Reply-To: <CAMP5XgfyUQT+mQ+SCFhyCSzAWevXUBpTXjpAYS54YTOb-PSpOg@mail.gmail.com>
X-OriginalArrivalTime: 05 Jun 2013 08:28:55.0158 (UTC) FILETIME=[B7929960:01CE61C6]
X-MC-Unique: 113060509285705601
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/13 00:58, Arve Hjønnevåg wrote:
> On Tue, Jun 4, 2013 at 1:54 AM, Serban Constantinescu
> <Serban.Constantinescu@arm.com> wrote:
>> On 03/06/13 22:41, Arve Hjønnevåg wrote:
>>>
>>> On Wed, May 22, 2013 at 3:12 AM, Serban Constantinescu
>>> <serban.constantinescu@arm.com> wrote:
>>>>
>>>> The changes in this patch will fix the binder interface for use on 64bit
>>>> machines and stand as the base of the 64bit compat support. The changes
>>>> apply to the structures that are passed between the kernel and
>>>> userspace.
>>>>
>>>> Most of the  changes applied mirror the change to struct binder_version
>>>> where there is no need for a 64bit wide protocol_version(on 64bit
>>>> machines). The change inlines with the existing 32bit userspace(the
>>>> structure has the same size) and simplifies the compat layer such that
>>>> the same handler can service the BINDER_VERSION ioctl.
>>>>
>>>> Other changes make use of kernel types as well as user-exportable ones
>>>> and fix format specifier issues.
>>>>
>>>> The changes do not affect existing 32bit ABI.
>>>>
>>>> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
>>>> ---
>>>>    drivers/staging/android/binder.c |   20 ++++++++++----------
>>>>    drivers/staging/android/binder.h |    8 ++++----
>>>>    2 files changed, 14 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/android/binder.c
>>>> b/drivers/staging/android/binder.c
>>>> index ce70909..ca79084 100644
>>>> --- a/drivers/staging/android/binder.c
>>>> +++ b/drivers/staging/android/binder.c
>>>> @@ -1271,7 +1271,7 @@ static void
>>>> binder_transaction_buffer_release(struct binder_proc *proc,
>>>>                   case BINDER_TYPE_WEAK_HANDLE: {
>>>>                           struct binder_ref *ref = binder_get_ref(proc,
>>>> fp->handle);
>>>>                           if (ref == NULL) {
>>>> -                               pr_err("transaction release %d bad handle
>>>> %ld\n",
>>>> +                               pr_err("transaction release %d bad handle
>>>> %d\n",
>>>>                                    debug_id, fp->handle);
>>>>                                   break;
>>>>                           }
>>>> @@ -1283,13 +1283,13 @@ static void
>>>> binder_transaction_buffer_release(struct binder_proc *proc,
>>>>
>>>>                   case BINDER_TYPE_FD:
>>>>                           binder_debug(BINDER_DEBUG_TRANSACTION,
>>>> -                                    "        fd %ld\n", fp->handle);
>>>> +                                    "        fd %d\n", fp->handle);
>>>>                           if (failed_at)
>>>>                                   task_close_fd(proc, fp->handle);
>>>>                           break;
>>>>
>>>>                   default:
>>>> -                       pr_err("transaction release %d bad object type
>>>> %lx\n",
>>>> +                       pr_err("transaction release %d bad object type
>>>> %x\n",
>>>>                                   debug_id, fp->type);
>>>>                           break;
>>>>                   }
>>>> @@ -1547,7 +1547,7 @@ static void binder_transaction(struct binder_proc
>>>> *proc,
>>>>                   case BINDER_TYPE_WEAK_HANDLE: {
>>>>                           struct binder_ref *ref = binder_get_ref(proc,
>>>> fp->handle);
>>>>                           if (ref == NULL) {
>>>> -                               binder_user_error("%d:%d got transaction
>>>> with invalid handle, %ld\n",
>>>> +                               binder_user_error("%d:%d got transaction
>>>> with invalid handle, %d\n",
>>>>                                                   proc->pid,
>>>>                                                   thread->pid,
>>>> fp->handle);
>>>>                                   return_error = BR_FAILED_REPLY;
>>>> @@ -1590,13 +1590,13 @@ static void binder_transaction(struct binder_proc
>>>> *proc,
>>>>
>>>>                           if (reply) {
>>>>                                   if (!(in_reply_to->flags &
>>>> TF_ACCEPT_FDS)) {
>>>> -                                       binder_user_error("%d:%d got
>>>> reply with fd, %ld, but target does not allow fds\n",
>>>> +                                       binder_user_error("%d:%d got
>>>> reply with fd, %d, but target does not allow fds\n",
>>>>                                                   proc->pid, thread->pid,
>>>> fp->handle);
>>>>                                           return_error = BR_FAILED_REPLY;
>>>>                                           goto err_fd_not_allowed;
>>>>                                   }
>>>>                           } else if (!target_node->accept_fds) {
>>>> -                               binder_user_error("%d:%d got transaction
>>>> with fd, %ld, but target does not allow fds\n",
>>>> +                               binder_user_error("%d:%d got transaction
>>>> with fd, %d, but target does not allow fds\n",
>>>>                                           proc->pid, thread->pid,
>>>> fp->handle);
>>>>                                   return_error = BR_FAILED_REPLY;
>>>>                                   goto err_fd_not_allowed;
>>>> @@ -1604,7 +1604,7 @@ static void binder_transaction(struct binder_proc
>>>> *proc,
>>>>
>>>>                           file = fget(fp->handle);
>>>>                           if (file == NULL) {
>>>> -                               binder_user_error("%d:%d got transaction
>>>> with invalid fd, %ld\n",
>>>> +                               binder_user_error("%d:%d got transaction
>>>> with invalid fd, %d\n",
>>>>                                           proc->pid, thread->pid,
>>>> fp->handle);
>>>>                                   return_error = BR_FAILED_REPLY;
>>>>                                   goto err_fget_failed;
>>>> @@ -1618,13 +1618,13 @@ static void binder_transaction(struct binder_proc
>>>> *proc,
>>>>                           task_fd_install(target_proc, target_fd, file);
>>>>                           trace_binder_transaction_fd(t, fp->handle,
>>>> target_fd);
>>>>                           binder_debug(BINDER_DEBUG_TRANSACTION,
>>>> -                                    "        fd %ld -> %d\n",
>>>> fp->handle, target_fd);
>>>> +                                    "        fd %d -> %d\n", fp->handle,
>>>> target_fd);
>>>>                           /* TODO: fput? */
>>>>                           fp->handle = target_fd;
>>>>                   } break;
>>>>
>>>>                   default:
>>>> -                       binder_user_error("%d:%d got transaction with
>>>> invalid object type, %lx\n",
>>>> +                       binder_user_error("%d:%d got transaction with
>>>> invalid object type, %x\n",
>>>>                                   proc->pid, thread->pid, fp->type);
>>>>                           return_error = BR_FAILED_REPLY;
>>>>                           goto err_bad_object_type;
>>>> @@ -2578,7 +2578,7 @@ static long binder_ioctl(struct file *filp,
>>>> unsigned int cmd, unsigned long arg)
>>>>                           goto err;
>>>>                   }
>>>>                   binder_debug(BINDER_DEBUG_READ_WRITE,
>>>> -                            "%d:%d write %zd at %08lx, read %zd at
>>>> %08lx\n",
>>>> +                            "%d:%d write %zd at %016lx, read %zd at
>>>> %016lx\n",
>>>>                                proc->pid, thread->pid, bwr.write_size,
>>>>                                bwr.write_buffer, bwr.read_size,
>>>> bwr.read_buffer);
>>>>
>>>> diff --git a/drivers/staging/android/binder.h
>>>> b/drivers/staging/android/binder.h
>>>> index edab249..2f94d16 100644
>>>> --- a/drivers/staging/android/binder.h
>>>> +++ b/drivers/staging/android/binder.h
>>>> @@ -48,13 +48,13 @@ enum {
>>>>     */
>>>>    struct flat_binder_object {
>>>>           /* 8 bytes for large_flat_header. */
>>>> -       unsigned long           type;
>>>> -       unsigned long           flags;
>>>> +       __u32           type;
>>>> +       __u32           flags;
>>>>
>>>>           /* 8 bytes of data. */
>>>>           union {
>>>>                   void __user     *binder;        /* local object */
>>>> -               signed long     handle;         /* remote object */
>>>> +               __s32       handle;             /* remote object */
>>>
>>>
>>> This should be unsigned to match the handle in binder_transaction_data
>>> and other uses in the driver, but it is currently also used to pass
>>> file descriptors. Perhaps this is better (if sou also change size of
>>> the handle in binder_transaction_data to match):
>>> __u32 handle; /* remote object */
>>> __s32 fd; /* file descriptor */
>>
>>
>> I will add this union and fix any uses of remote object/ file descriptor
>> accordingly.
>>
>>
>>>
>>>>           };
>>>>
>>>>           /* extra data associated with local object */
>>>> @@ -78,7 +78,7 @@ struct binder_write_read {
>>>>    /* Use with BINDER_VERSION, driver fills in fields. */
>>>>    struct binder_version {
>>>>           /* driver protocol version -- increment with incompatible change
>>>> */
>>>> -       signed long     protocol_version;
>>>> +       __s32       protocol_version;
>>>>    };
>>>>
>>>>    /* This is the current protocol version. */
>>>> --
>>>> 1.7.9.5
>>>>
>>>
>>> I still think the protocol_version size change on 64 bit systems
>>> should go after all your other changes that affect 64 bits systems.
>>> That way you don't have to change the protocol version later.
>>
>> At the end of this patch set we will have support for 32/32 and 64/64 binder
>> calls. This patch does not add compat support for 64/32 systems and will not
>> work for this configuration.
>>
>> However until we add:
>>
>>> static const struct file_operations binder_fops = {
>>>          .owner = THIS_MODULE,
>>>          .poll = binder_poll,
>>>          .unlocked_ioctl = binder_ioctl,
>>> +       .compat_ioctl = binder_ioctl,
>>>          .mmap = binder_mmap,
>>>          .open = binder_open,
>>>          .flush = binder_flush,
>>
>>
>> The return value for any binder ioctl from a 32bit userspace running on top
>> of a 64bit kernel will be EINVAL (this happens only for 64/32 systems). Once
>> we have the compat layer upstreamed we will add the above change, but until
>> that point querying the binder version or any other binder iocall will fail
>> (on 64/32).
>>
>> Let me know if you consider that changing the binder version to use __s32
>> when adding the compat layer would be better.
>>
>
> If the ioctl fails on for a 32 bit process on a 64 bit kernel, you can
> change the size before adding the compat_ioctl, but you need to finish
> all the changes that affect a 64/64 system first. You can either split
> this change in two or move the entire change to the end of your
> patch-set. Can you also post your changes that add 64/32 support?

Thanks again for the feedback - I will split the binder version change 
into its own patch.

I will rework my binder compat changes based on a 3.10 kernel and resend 
them.

Regards,
Serban

