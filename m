Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab3G3WgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 18:36:16 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:39068 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3G3WgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 18:36:15 -0400
MIME-Version: 1.0
In-Reply-To: <51F7BB2A.2090803@redhat.com>
References: <1375178347-29037-1-git-send-email-zwu.kernel@gmail.com>
	<51F7BB2A.2090803@redhat.com>
Date: Wed, 31 Jul 2013 06:36:13 +0800
Message-ID: <CAEH94LgDG9iaHYsh0t=oq+AXfMGw_7WywzVeDsRHMbBEYrrZtQ@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: introduce object readahead to log recovery
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Brian Foster <bfoster@redhat.com>
Cc: xfstests <xfs@oss.sgi.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 9:10 PM, Brian Foster <bfoster@redhat.com> wrote:
> On 07/30/2013 05:59 AM, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   It can take a long time to run log recovery operation because it is
>> single threaded and is bound by read latency. We can find that it took
>> most of the time to wait for the read IO to occur, so if one object
>> readahead is introduced to log recovery, it will obviously reduce the
>> log recovery time.
>>
>> Log recovery time stat:
>>
>>           w/o this patch        w/ this patch
>>
>> real:        0m15.023s             0m7.802s
>> user:        0m0.001s              0m0.001s
>> sys:         0m0.246s              0m0.107s
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>
> Cool patch. I'm not terribly familiar with the log recovery code so take
> my comments with a grain of salt, but a couple things I noticed on a
> quick skim...
>
>>  fs/xfs/xfs_log_recover.c | 162 +++++++++++++++++++++++++++++++++++++++++++++--
>>  fs/xfs/xfs_log_recover.h |   2 +
>>  2 files changed, 159 insertions(+), 5 deletions(-)
>>
> ...
>>
>> +STATIC int
>> +xlog_recover_items_pass2(
>> +     struct xlog                     *log,
>> +     struct xlog_recover             *trans,
>> +     struct list_head                *buffer_list,
>> +     struct list_head                *ra_list)
>
> A nit, but technically this function doesn't have to be involved with
> readahead. Perhaps rename ra_list to item_list..?
ok, applied.
>
>> +{
>> +     int                     error = 0;
>> +     xlog_recover_item_t     *item;
>> +
>> +     list_for_each_entry(item, ra_list, ri_list) {
>> +             error = xlog_recover_commit_pass2(log, trans,
>> +                                       buffer_list, item);
>> +             if (error)
>> +                     return error;
>> +     }
>> +
>> +     return error;
>> +}
>> +
>>  /*
>>   * Perform the transaction.
>>   *
>> @@ -3189,9 +3314,11 @@ xlog_recover_commit_trans(
>>       struct xlog_recover     *trans,
>>       int                     pass)
>>  {
>> -     int                     error = 0, error2;
>> -     xlog_recover_item_t     *item;
>> +     int                     error = 0, error2, ra_qdepth = 0;
>> +     xlog_recover_item_t     *item, *next;
>>       LIST_HEAD               (buffer_list);
>> +     LIST_HEAD               (ra_list);
>> +     LIST_HEAD               (all_ra_list);
>>
>>       hlist_del(&trans->r_list);
>>
>> @@ -3199,14 +3326,21 @@ xlog_recover_commit_trans(
>>       if (error)
>>               return error;
>>
>> -     list_for_each_entry(item, &trans->r_itemq, ri_list) {
>> +     list_for_each_entry_safe(item, next, &trans->r_itemq, ri_list) {
>>               switch (pass) {
>>               case XLOG_RECOVER_PASS1:
>>                       error = xlog_recover_commit_pass1(log, trans, item);
>>                       break;
>>               case XLOG_RECOVER_PASS2:
>> -                     error = xlog_recover_commit_pass2(log, trans,
>> -                                                       &buffer_list, item);
>> +                     if (ra_qdepth++ >= XLOG_RECOVER_MAX_QDEPTH) {
>
> The counting mechanism looks strange and easy to break with future
> changes. Why not increment ra_qdepth in the else bracket where it is
> explicitly tied to the operation it tracks?
ok.
>
>> +                             error = xlog_recover_items_pass2(log, trans,
>> +                                             &buffer_list, &ra_list);
>> +                             list_splice_tail_init(&ra_list, &all_ra_list);
>> +                             ra_qdepth = 0;
>
> So now we've queued up a bunch of items we've issued readahead on in
> ra_list and we've executed the recovery on the list. What happens to the
> current item?
Good catch, the current item was missed. Done.
>
> Brian
>
>> +                     } else {
>> +                             xlog_recover_ra_pass2(log, item);
>> +                             list_move_tail(&item->ri_list, &ra_list);
>> +                     }
>>                       break;
>>               default:
>>                       ASSERT(0);
>> @@ -3216,9 +3350,27 @@ xlog_recover_commit_trans(
>>                       goto out;
>>       }
>>
>> +     if (!list_empty(&ra_list)) {
>> +             error = xlog_recover_items_pass2(log, trans,
>> +                             &buffer_list, &ra_list);
>> +             if (error)
>> +                     goto out;
>> +
>> +             list_splice_tail_init(&ra_list, &all_ra_list);
>> +     }
>> +
>> +     if (!list_empty(&all_ra_list))
>> +             list_splice_init(&all_ra_list, &trans->r_itemq);
>> +
>>       xlog_recover_free_trans(trans);
>>
>>  out:
>> +     if (!list_empty(&ra_list))
>> +             list_splice_tail_init(&ra_list, &all_ra_list);
>> +
>> +     if (!list_empty(&all_ra_list))
>> +             list_splice_init(&all_ra_list, &trans->r_itemq);
>> +
>>       error2 = xfs_buf_delwri_submit(&buffer_list);
>>       return error ? error : error2;
>>  }
>> diff --git a/fs/xfs/xfs_log_recover.h b/fs/xfs/xfs_log_recover.h
>> index 1c55ccb..16322f6 100644
>> --- a/fs/xfs/xfs_log_recover.h
>> +++ b/fs/xfs/xfs_log_recover.h
>> @@ -63,4 +63,6 @@ typedef struct xlog_recover {
>>  #define      XLOG_RECOVER_PASS1      1
>>  #define      XLOG_RECOVER_PASS2      2
>>
>> +#define XLOG_RECOVER_MAX_QDEPTH 100
>> +
>>  #endif       /* __XFS_LOG_RECOVER_H__ */
>>
>



-- 
Regards,

Zhi Yong Wu
