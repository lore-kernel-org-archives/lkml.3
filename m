Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab3FRQSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:18:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35789 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933205Ab3FRQSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:18:41 -0400
Message-ID: <51C08865.2050104@arm.com>
Date: Tue, 18 Jun 2013 17:18:45 +0100
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
X-OriginalArrivalTime: 18 Jun 2013 16:18:37.0003 (UTC) FILETIME=[7CA1A1B0:01CE6C3F]
X-MC-Unique: 113061817183907101
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Sorry for the late reply on this patch set - I had to re-prioritise some 
of the other tasks I am currently working on. v5 of this patch set 
should be out the door soon.

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


The cleaner change would be to have an __u32 handle that is used in both 
cases (fd/ uint handle). Adding __s32 fd to the union would cause either 
inconsistency with other function definitions or a big set of changes. 
See for example binder_transaction_buffer_release(), case BINDER_TYPE_FD 
- task_close_fd(), __close_fd().

I will change the struct flat_binder_object to use an __u32 handle for 
v5. Let me know if you have other thoughts on this.


Thanks,
Serban

