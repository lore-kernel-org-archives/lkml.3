Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbaHZPBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:01:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58034 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756087AbaHZPBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:01:32 -0400
Message-ID: <53FCA148.6020002@fb.com>
Date: Tue, 26 Aug 2014 09:01:28 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: /proc/diskstats buglet
References: <CACVxJT8LW4NOj7ksbcmfHig7MjJTK3AabZbnzWcNPNfznwPKrw@mail.gmail.com>	<53FC9FF5.7060106@fb.com> <CACVxJT_usd+8bDnctx6+4kgozE1GDONA+a+W+QWaa_tzuKCUEg@mail.gmail.com>
In-Reply-To: <CACVxJT_usd+8bDnctx6+4kgozE1GDONA+a+W+QWaa_tzuKCUEg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-26_05:2014-08-26,2014-08-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=7.03975766569442e-12 kscore.compositescore=0
 circleOfTrustscore=3224.31981307066 compositescore=0.324642340081358
 urlsuspect_oldscore=0.324642340081358 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.324642340081358 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408260170
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 09:00 AM, Alexey Dobriyan wrote:
> On Tue, Aug 26, 2014 at 5:55 PM, Jens Axboe <axboe@fb.com> wrote:
>> On 08/26/2014 08:47 AM, Alexey Dobriyan wrote:
>>> Found and reproduced some time ago, almost forgot about :-)
>>>
>>> In part_round_stats_single(), ->stamp field is written but without
>>> locking SMP-wise.
>>>
>>>     part->stamp = now;
>>>
>>> So, if two processes read /proc/diskstats, it is possible for "now -
>>> part->stamp" value to become negative.
>>>
>>> And indeed this can happen:
>>>
>>> now 4294755500, ->stamp 4294755501
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 0 PID: 1950 at block/blk-core.c:1229
>>> part_round_stats_single+0xc0/0xd0()
>>>  ...
>>>  [<ffffffff811963f0>] part_round_stats_single+0xc0/0xd0
>>>  [<ffffffff81196447>] part_round_stats+0x47/0x70
>>>  [<ffffffff811a069d>] diskstats_show+0x8d/0x4b0
>>>  ...
>>>
>>> Dunno how important used fields in /proc/diskstats but they can be
>>> clearly bogus.
>>
>> Easiest fix is probably just to do the now - part->stamp math earlier,
>> and ignore <= 0 instead of just now == part->stamp. I think that should
>> be good enough for disk stats, and (most importantly), it would avoid
>> the warning.
>>
>> Speaking of the warning, I don't see where that is. Where is it from?
> 
> I inserted the warning to be sure bug exists and I am not misreading the code.

Ah got it, that makes sense. Care to send a patch to just ignore <= 0
now - part->stamp?

-- 
Jens Axboe

