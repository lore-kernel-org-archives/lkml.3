Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaHSFfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 01:35:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26627 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586AbaHSFfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 01:35:16 -0400
Message-ID: <53F2E132.10701@marvell.com>
Date: Tue, 19 Aug 2014 13:31:30 +0800
From: Leo Yan <leoy@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chao Xie <cxie4@marvell.com>, Leo Song <liangs@marvell.com>,
        Lu Mao <ylmao@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [Question]: redundant interrupts for broadcast timer
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-19_01:2014-08-18,2014-08-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408190072
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

We observed the redundant interrupts for broadcast timer, so want to 
confirm here firstly; pls see below flow:

1. Thread_A starts a hrtimer with 100ms timeout, and then thread_A will 
remove from the runqueue to sleep;
2. The CPU which thread_A runs on will enter idle and call notify 
CLOCK_EVT_NOTIFY_BROADCAST_ENTER, so the CPU will shutdown its local 
timer and set broadcast timer's next event with delta for 100ms;
3. After 70ms later, the CPU is waken up by other peripheral's interrupt 
and thread_A will be waken up as well; thread_A will cancel the hrtimer 
at this point, kernel will remove the timer event from the event queue 
but it will not disable broadcast timer;
4. So after 30ms later, the broadcast timer interrupt will be triggered 
even though the timer has been cancelled by s/w in step 3.

With current timer framework, is upper behaviour expected? Or maybe we 
miss something so that introduce such kind issue?

And i'm interesting now if have some idea to optimize such issue, very 
appreciate for suggestion and comment.

Thanks,
Leo Yan
