Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbaDGRR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:17:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19763 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755405AbaDGRRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:17:24 -0400
Message-ID: <5342DD99.3010502@fb.com>
Date: Mon, 7 Apr 2014 13:17:13 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <dsterba@suse.cz>, Sasha Levin <sasha.levin@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>, <jbacik@fb.com>,
        <linux-btrfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: btrfs: lock inversion between delayed_node->mutex and found->groups_sem
References: <53239AE0.8030306@oracle.com> <20140317130546.GE29256@twin.jikos.cz> <533307ED.8030700@suse.com> <533F20EB.2040500@oracle.com> <20140407165449.GA29256@twin.jikos.cz>
In-Reply-To: <20140407165449.GA29256@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-07_02:2014-04-07,2014-04-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=6.66133814775094e-16 kscore.compositescore=0
 circleOfTrustscore=9.18185114672389 compositescore=0.998981209195878
 urlsuspect_oldscore=0.998981209195878 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998981209195878 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404070142
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/07/2014 12:54 PM, David Sterba wrote:
> On Fri, Apr 04, 2014 at 05:15:23PM -0400, Sasha Levin wrote:
>> On 03/26/2014 01:01 PM, Jeff Mahoney wrote:
>>> On 3/17/14, 9:05 AM, David Sterba wrote:
>>>>> On Fri, Mar 14, 2014 at 08:12:16PM -0400, Sasha Levin wrote:
>>>>>>> While fuzzing with trinity inside a KVM tools guest running the latest -next kernel I've stumbled on the following:
>>>>>>>
>>>>>>> [  788.458756]        CPU0                    CPU1 [  788.459188] ----                    ---- [  788.459625] lock(&found->groups_sem); [  788.460041] local_irq_disable(); [  788.460041] lock(&delayed_node->mutex); [  788.460041] lock(&found->groups_sem); [  788.460041]   <Interrupt> [ 788.460041]     lock(&delayed_node->mutex); [  788.460041] [ 788.460041]  *** DEADLOCK *** [  788.460041] [  788.460041] 2 locks held by kswapd3/4199:
>>>>>
>>>>> I've once (3.14-rc5) seen the same warning also caused by xfstests/generic/224
>>> I think this is from my sysfs patches. We call kobject_add while holding the group_sem. kobject_add ultimately allocates with GFP_KERNEL, so it can enter reclaim. This particular case isn't dangerous, but it could hit while hot-adding a device. The fix should be pretty simple.
>>
>> Is that fix available anywhere? I'm still seeing the issue in -next.
>
> It is: https://urldefense.proofpoint.com/v1/url?u=https://patchwork.kernel.org/patch/3894781/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=HQJVSK4wPTft1zWwI1cGvwj5OfdmN5UItVlucU1K31o%3D%0A&s=5113699a2e7345a779333c87dd5b1d88b4410a7c7fcd5fa424baeb838ad7d31b , will probably hit -rc2
>

Its in the integration branch now along with some other important fixes. 
  We'll get it out shortly

-chris
