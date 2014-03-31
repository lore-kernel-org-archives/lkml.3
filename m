Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaCaI2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 04:28:46 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:34815 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaCaI2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 04:28:43 -0400
MIME-Version: 1.0
In-Reply-To: <1396216043.2579.11.camel@buesod1.americas.hpqcorp.net>
References: <1396186538-3378-1-git-send-email-minipli@googlemail.com>
	<1396216043.2579.11.camel@buesod1.americas.hpqcorp.net>
Date: Mon, 31 Mar 2014 10:28:41 +0200
Message-ID: <CA+rthh93hc5w_yKMLyJmEZFrW0NbHU3TEf_YL4cpE5OT3hvpLQ@mail.gmail.com>
Subject: Re: [PATCH] ipc: constify ipc_ops
From: Mathias Krause <minipli@googlemail.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        PaX Team <pageexec@freemail.hu>, Nadia Derbey <Nadia.Derbey@bull.net>,
        Manfred Spraul <manfred@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 March 2014 23:47, Davidlohr Bueso <davidlohr@hp.com> wrote:
> On Sun, 2014-03-30 at 15:35 +0200, Mathias Krause wrote:
>> There is no need to recreate the very same ipc_ops structure on every
>> kernel entry for msgget/semget/shmget. Just declare it static and be
>> done with it.
>> While at it, constify it as we don't modify the structure at runtime.
>
> Seems reasonable.
>
>>
>> Found in the PaX patch, written by the PaX Team.
>>
>> Cc: PaX Team <pageexec@freemail.hu>
>> Cc: Nadia Derbey <Nadia.Derbey@bull.net>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Mathias Krause <minipli@googlemail.com>
>
> In the future, for ipc changes, please CC me and Manfred as well.

As there is no maintainer entry for ipc/ in the MAINTAINERS file I
looked at the recent commit history of ipc/ and found that most of the
patches went in via Andrew and then Linus. But it's true, you and
Manfred have quite some patches in the recent past. Though, having an
official maintaner for ipc/ would accelerate the gyrating phase of
whom to send the patches to in the future. Are you volunteering? :)

>
> One comment below, otherwise:
> Acked-by: Davidlohr Bueso <davidlohr@hp.com>
>
>> ---
>>  ipc/msg.c  |    9 ++++-----
>>  ipc/sem.c  |   10 +++++-----
>>  ipc/shm.c  |   10 +++++-----
>>  ipc/util.c |    8 ++++----
>>  ipc/util.h |    2 +-
>>  5 files changed, 19 insertions(+), 20 deletions(-)
>>
>> diff --git a/ipc/msg.c b/ipc/msg.c
>> index 649853105a..35e4018de5 100644
>> --- a/ipc/msg.c
>> +++ b/ipc/msg.c
>> @@ -306,15 +306,14 @@ static inline int msg_security(struct kern_ipc_perm *ipcp, int msgflg)
>>  SYSCALL_DEFINE2(msgget, key_t, key, int, msgflg)
>>  {
>>       struct ipc_namespace *ns;
>> -     struct ipc_ops msg_ops;
>> +     static const struct ipc_ops msg_ops = {
>> +             .getnew = newque,
>> +             .associate = msg_security,
>
> For completeness, please add .more_checks = NULL as well.

The C standard already ensures that .more_checks is initialized with
NULL. So I don't see any benefit from doing it explicitly.
We're not initializing global/static variables holding NULL pointers
in the majority of the code base either, so this is just "best
practice".
Also, in case somebody adds another member to struct ipc_ops, he also
would have to add a '.new_member = NULL' to all places using ipc_ops
but not needing the new member? Makes no sense to me. It would just
add noise to that patch.

>
>> +     };
>>       struct ipc_params msg_params;
>>
>>       ns = current->nsproxy->ipc_ns;
>>
>> -     msg_ops.getnew = newque;
>> -     msg_ops.associate = msg_security;
>> -     msg_ops.more_checks = NULL;
>> -
>>       msg_params.key = key;
>>       msg_params.flg = msgflg;
>>
>> diff --git a/ipc/sem.c b/ipc/sem.c
>> index bee5554173..3fcbc96abe 100644
>> --- a/ipc/sem.c
>> +++ b/ipc/sem.c
>> @@ -564,7 +564,11 @@ static inline int sem_more_checks(struct kern_ipc_perm *ipcp,
>>  SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
>>  {
>>       struct ipc_namespace *ns;
>> -     struct ipc_ops sem_ops;
>> +     static const struct ipc_ops sem_ops = {
>> +             .getnew = newary,
>> +             .associate = sem_security,
>> +             .more_checks = sem_more_checks,
>> +     };
>>       struct ipc_params sem_params;
>>
>>       ns = current->nsproxy->ipc_ns;
>> @@ -572,10 +576,6 @@ SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
>>       if (nsems < 0 || nsems > ns->sc_semmsl)
>>               return -EINVAL;
>>
>> -     sem_ops.getnew = newary;
>> -     sem_ops.associate = sem_security;
>> -     sem_ops.more_checks = sem_more_checks;
>> -
>>       sem_params.key = key;
>>       sem_params.flg = semflg;
>>       sem_params.u.nsems = nsems;
>> diff --git a/ipc/shm.c b/ipc/shm.c
>> index 76459616a7..b54c93f6d1 100644
>> --- a/ipc/shm.c
>> +++ b/ipc/shm.c
>> @@ -609,15 +609,15 @@ static inline int shm_more_checks(struct kern_ipc_perm *ipcp,
>>  SYSCALL_DEFINE3(shmget, key_t, key, size_t, size, int, shmflg)
>>  {
>>       struct ipc_namespace *ns;
>> -     struct ipc_ops shm_ops;
>> +     static const struct ipc_ops shm_ops = {
>> +             .getnew = newseg,
>> +             .associate = shm_security,
>> +             .more_checks = shm_more_checks,
>> +     };
>>       struct ipc_params shm_params;
>>
>>       ns = current->nsproxy->ipc_ns;
>>
>> -     shm_ops.getnew = newseg;
>> -     shm_ops.associate = shm_security;
>> -     shm_ops.more_checks = shm_more_checks;
>> -
>>       shm_params.key = key;
>>       shm_params.flg = shmflg;
>>       shm_params.u.size = size;
>> diff --git a/ipc/util.c b/ipc/util.c
>> index e1b4c6db8a..314ebeb3d7 100644
>> --- a/ipc/util.c
>> +++ b/ipc/util.c
>> @@ -317,7 +317,7 @@ int ipc_addid(struct ipc_ids *ids, struct kern_ipc_perm *new, int size)
>>   * when the key is IPC_PRIVATE.
>>   */
>>  static int ipcget_new(struct ipc_namespace *ns, struct ipc_ids *ids,
>> -             struct ipc_ops *ops, struct ipc_params *params)
>> +             const struct ipc_ops *ops, struct ipc_params *params)
>>  {
>>       int err;
>>
>> @@ -344,7 +344,7 @@ static int ipcget_new(struct ipc_namespace *ns, struct ipc_ids *ids,
>>   */
>>  static int ipc_check_perms(struct ipc_namespace *ns,
>>                          struct kern_ipc_perm *ipcp,
>> -                        struct ipc_ops *ops,
>> +                        const struct ipc_ops *ops,
>>                          struct ipc_params *params)
>>  {
>>       int err;
>> @@ -375,7 +375,7 @@ static int ipc_check_perms(struct ipc_namespace *ns,
>>   * On success, the ipc id is returned.
>>   */
>>  static int ipcget_public(struct ipc_namespace *ns, struct ipc_ids *ids,
>> -             struct ipc_ops *ops, struct ipc_params *params)
>> +             const struct ipc_ops *ops, struct ipc_params *params)
>>  {
>>       struct kern_ipc_perm *ipcp;
>>       int flg = params->flg;
>> @@ -678,7 +678,7 @@ out:
>>   * Common routine called by sys_msgget(), sys_semget() and sys_shmget().
>>   */
>>  int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
>> -                     struct ipc_ops *ops, struct ipc_params *params)
>> +                     const struct ipc_ops *ops, struct ipc_params *params)
>>  {
>>       if (params->key == IPC_PRIVATE)
>>               return ipcget_new(ns, ids, ops, params);
>> diff --git a/ipc/util.h b/ipc/util.h
>> index 9c47d6f6c7..e1153ad574 100644
>> --- a/ipc/util.h
>> +++ b/ipc/util.h
>> @@ -201,7 +201,7 @@ static inline bool ipc_valid_object(struct kern_ipc_perm *perm)
>>
>>  struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id);
>>  int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
>> -                     struct ipc_ops *ops, struct ipc_params *params);
>> +                     const struct ipc_ops *ops, struct ipc_params *params);
>>  void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
>>               void (*free)(struct ipc_namespace *, struct kern_ipc_perm *));
>>  #endif
>
>

Thanks,
Mathias
