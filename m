Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbaHHOnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:43:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14143 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754756AbaHHOnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:43:07 -0400
Message-ID: <53E4E1F5.8090409@fb.com>
Date: Fri, 8 Aug 2014 10:43:01 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs BUG() in __set_extent_bit on GFP_ATOMIC failure.
References: <20140808042659.GA28040@redhat.com>
In-Reply-To: <20140808042659.GA28040@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-08_04:2014-08-08,2014-08-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.2170373842334e-07 kscore.compositescore=0
 circleOfTrustscore=112.429318596174 compositescore=0.998981209195878
 urlsuspect_oldscore=0.998981209195878 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998981209195878 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408080176
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 12:26 AM, Dave Jones wrote:
> While playing with fault injection, I hit this quite easily.
> 
> kernel BUG at fs/btrfs/extent_io.c:990!
> invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> CPU: 1 PID: 1270 Comm: fsx Not tainted 3.16.0+ #41
> task: ffff88023fe46d60 ti: ffff8802405a8000 task.ti: ffff8802405a8000
> RIP: 0010:[<ffffffffc0319af4>]  [<ffffffffc0319af4>] __set_extent_bit+0x574/0x660 [btrfs]
> ...
>  [<ffffffff851be7fc>] ? set_track+0x9c/0x140
>  [<ffffffffc031aa94>] lock_extent_bits+0x94/0x310 [btrfs]
>  [<ffffffff85166454>] ? pagecache_get_page+0xb4/0x210
>  [<ffffffffc030d4de>] lock_and_cleanup_extent_if_need+0xee/0x1f0 [btrfs]
>  [<ffffffffc030e6e1>] __btrfs_buffered_write+0x1b1/0x680 [btrfs]
>  [<ffffffff850a258b>] ? preempt_count_sub+0xab/0x100
>  [<ffffffffc030ed2e>] btrfs_file_write_iter+0x17e/0x570 [btrfs]
>  [<ffffffff851d78ce>] new_sync_write+0x8e/0xd0
>  [<ffffffff851d8127>] vfs_write+0xb7/0x1f0
>  [<ffffffff851d8d68>] SyS_write+0x58/0xd0
>  [<ffffffff8576371f>] tracesys+0xdd/0xe2
> 
> 
>  989                 prealloc = alloc_extent_state_atomic(prealloc);
>  990                 BUG_ON(!prealloc);
> 
>  541 static struct extent_state *
>  542 alloc_extent_state_atomic(struct extent_state *prealloc)
>  543 {
>  544         if (!prealloc)
>  545                 prealloc = alloc_extent_state(GFP_ATOMIC);
>  546 
>  547         return prealloc;
>  548 }
> 
> 
> Going BUG() on a GFP_ATOMIC allocation failure seems a bit excessive.
> Surely there's something better we can do here ?
> 

Ugh, yes we can.  It should jump back to outside the lock and get the
prealloc there.

-chris

