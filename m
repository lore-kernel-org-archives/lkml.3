Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3GCBZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 21:25:46 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:63465 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3GCBZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 21:25:45 -0400
Date: Wed, 3 Jul 2013 09:25:39 +0800
From: majianpeng <majianpeng@gmail.com>
To: sage <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: Re: Re: [PATCH 1/3] mds: update atime if client can read.
References: <201307021345090019137@gmail.com>, 
	<alpine.DEB.2.00.1307020946520.1067@cobra.newdream.net>
X-Priority: 3
X-GUID: 0891D6D3-5563-402D-BAB6-682D5F8A4939
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201307030925331606702@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r631PwaG011592

>On Tue, 2 Jul 2013, majianpeng wrote:
>> Now, update atime only for CEPH_CAP_FILE_EXCL.Change this if
>> CEPH_CAP_FILE_RD.
>
>Can we introduce a global config optoin (bool mds_atime in 
>common/config_opts.h, maybe) so that users can turn this off?  And/or add 
>a 'relatime' option?  More users won't want this as it is very expensive 
>to maintain this extra level of metadata.
>
I don't know other client except cephfs.So the patch is from the view of using cephfs.
For cephfs,we can mount using 'noatime' to indicate don't update atime.
But for the other client, i don't know.
I think this should controled by client not server.

>That aside, this approach looks right to me. :)
>
>Thanks!
>sage
>
>
> > 
>> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
>> ---
>>  src/mds/Locker.cc | 15 +++++++++------
>>  1 file changed, 9 insertions(+), 6 deletions(-)
>> 
>> diff --git a/src/mds/Locker.cc b/src/mds/Locker.cc
>> index 30e014a..58f953f 100644
>> --- a/src/mds/Locker.cc
>> +++ b/src/mds/Locker.cc
>> @@ -2676,8 +2676,9 @@ void Locker::_do_snap_update(CInode *in, snapid_t snap, int dirty, snapid_t foll
>>  void Locker::_update_cap_fields(CInode *in, int dirty, MClientCaps *m, inode_t *pi)
>>  {
>>    // file
>> +  utime_t atime = m->get_atime();
>> +
>>    if (dirty & (CEPH_CAP_FILE_EXCL|CEPH_CAP_FILE_WR)) {
>> -    utime_t atime = m->get_atime();
>>      utime_t mtime = m->get_mtime();
>>      utime_t ctime = m->get_ctime();
>>      uint64_t size = m->get_size();
>> @@ -2700,11 +2701,7 @@ void Locker::_update_cap_fields(CInode *in, int dirty, MClientCaps *m, inode_t *
>>        pi->size = size;
>>        pi->rstat.rbytes = size;
>>      }
>> -    if ((dirty & CEPH_CAP_FILE_EXCL) && atime != pi->atime) {
>> -      dout(7) << "  atime " << pi->atime << " -> " << atime
>> -	      << " for " << *in << dendl;
>> -      pi->atime = atime;
>> -    }
>> +    
>>      if ((dirty & CEPH_CAP_FILE_EXCL) &&
>>  	ceph_seq_cmp(pi->time_warp_seq, m->get_time_warp_seq()) < 0) {
>>        dout(7) << "  time_warp_seq " << pi->time_warp_seq << " -> " << m->get_time_warp_seq()
>> @@ -2712,6 +2709,12 @@ void Locker::_update_cap_fields(CInode *in, int dirty, MClientCaps *m, inode_t *
>>        pi->time_warp_seq = m->get_time_warp_seq();
>>      }
>>    }
>> +  
>> +  if ((dirty & CEPH_CAP_FILE_RD) && atime > pi->atime) {
>> +      dout(7) << "  atime " << pi->atime << " -> " << atime
>> +	      << " for " << *in << dendl;
>> +      pi->atime = atime;
>> +  }
>>    // auth
>>    if (dirty & CEPH_CAP_AUTH_EXCL) {
>>      if (m->head.uid != pi->uid) {
>> -- 
>> 1.8.3.rc1.44.gb387c77
>> ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
