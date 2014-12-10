Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbaLJDMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 22:12:13 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15890 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651AbaLJDML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 22:12:11 -0500
Date: Tue, 9 Dec 2014 19:11:02 -0800
From: Calvin Owens <calvinowens@fb.com>
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: Re: [PATCH] x86: mce: Avoid timer double-add during CMCI interrupt
 storms.
Message-ID: <20141210031102.GB1437888@mail.thefacebook.com>
References: <1417746575-23299-1-git-send-email-calvinowens@fb.com>
 <20141209180835.GF3990@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329640BC@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F329640BC@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-10_01:2014-12-09,2014-12-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=26.7046773694174
 compositescore=0.928862112264561 urlsuspect_oldscore=0.928862112264561
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.928862112264561 spamscore=0
 recipient_to_sender_domain_totalscore=46 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412100031
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12/09 at 23:00 +0000, Luck, Tony wrote:
> > Right, so this polling thing once again proves its fragility to me - we
> > have had problems with it in the past so maybe we should think about
> > replacing it with something simpler and and much more robust instead of
> > this flaky dynamically adjustable polling thing.
> 
> Dynamic intervals for polling make sense for cpus that don't support
> CMCI.  We need to check occasionally to see if there are any corrected errors,
> but we don't want to waste a lot of cpu time doing that too often. There are
> almost never any errors to be found. So begin polling at 5 minute intervals
> (eternity on a multi-GHz cpu). If we do find an error, then look more frequently,
> because there are several cases where a single error source might generate
> multiple errors (e.g. stuck bit).
> 
> But then we came along an co-opted this mechanism  for CMCI storm
> control.  And you are right that we made things needlessly complex
> by using the same variable rate mechanism.  If we had a storm, we know
> we are having a high rate of errors (15 in one second) ... so we just want
> to poll at a high-ish rate to collect a good sample of subsequent errors.
> Also to detect when the storm ends in a timely manner. So we don't
> gain much by tweaking the poll rate, and we have complex code.
> 
> > So I'm thinking of leaving the detection code as it is, when we detect
> > a storm on a CPU, we set CMCI_STORM_ACTIVE and start a kernel thread at
> > max freq HZ/100 and polling the MCA banks. No adjustable frequency, no
> > timers, no nothing. A stupid per-cpu thread which polls.
> 
> Go for it.

Just to make sure I understand what you're looking for:

When MCE is initialized, spawn a kthread for each CPU instead of the
current timers. If CMCI is supported, we just leave this thread parked,
and only process errors from the CMCI interrupt handler.

When a CMCI storm happens, we disable CMCI interrupts and kick the
kthread, which polls every HZ/100 until the storm has subsided, at which
point it re-enables CMCI interrupts and parks itself.

If CMCI isn't supported though, how is the polling done? You said the
dynamic interval is desirable, wouldn't that need to be in the kthread?
Having both the kthread and the timer around seems ugly, even if only
one is used on a given machine.

Thanks,
Calvin
