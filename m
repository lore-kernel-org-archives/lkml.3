Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbaLJTmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:42:16 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31744 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932319AbaLJTmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:42:14 -0500
Date: Wed, 10 Dec 2014 11:41:52 -0800
From: Shaohua Li <shli@fb.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, <kernel-team@fb.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/3] X86: add a generic API to let vdso code detect
 context switch
Message-ID: <20141210194152.GA14261@devbig257.prn2.facebook.com>
References: <f0f3eab5f68f74bfabf42d745ccf1e2ecf642683.1418006970.git.shli@fb.com>
 <238c10795d7be218fea8d16ceb183e1e7450da0b.1418006970.git.shli@fb.com>
 <CALCETrW3NZmWEffa+G+c40zcuPcBAzckfn47bLh8-L2G+SfV=g@mail.gmail.com>
 <20141210185116.GA12098@devbig257.prn2.facebook.com>
 <CALCETrUTgpxB1D43tjtv9So6k4H0OXzLXGJateYZtZahGXd4Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CALCETrUTgpxB1D43tjtv9So6k4H0OXzLXGJateYZtZahGXd4Sw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-10_08:2014-12-10,2014-12-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=21.7374254348843
 compositescore=0.923639739835017 urlsuspect_oldscore=0.923639739835017
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.923639739835017 spamscore=0
 recipient_to_sender_domain_totalscore=35 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412100186
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 11:11:27AM -0800, Andy Lutomirski wrote:
> On Wed, Dec 10, 2014 at 10:51 AM, Shaohua Li <shli@fb.com> wrote:
> > On Wed, Dec 10, 2014 at 10:38:41AM -0800, Andy Lutomirski wrote:
> >> On Sun, Dec 7, 2014 at 7:03 PM, Shaohua Li <shli@fb.com> wrote:
> >> > vdso code can't disable preempt, so it can be preempted at any time.
> >> > This makes a challenge to implement specific features. This patch adds a
> >> > generic API to let vdso code detect context switch.
> >> >
> >> > With this patch, every cpu maintains a context switch count. The upper
> >> > bits of the count is the logical cpu id, so the count can't be identical
> >> > for any cpu. The low bits of the count will be increased for each
> >> > context switch. For a x86_64 cpu with 4096 cpus, the context switch will
> >> > be overflowed for 2^(64 - 12) context switch, which is a long time and can be
> >> > ignored. The change of the count in giving time can be used to detect if
> >> > context switch occurs.
> >>
> >> Why do you need those high bits?  I don't understand how you could
> >> possibly confuse one cpu's count with another's unless you fail to
> >> make sure that you're reading the same address both times.
> >>
> >> That being said, I don't like this patch.  I'm not sure I have a much
> >> better idea, though.  More thoughts in the 0/0 email to follow.
> > the vdso code doesn't disable preemption, so it can be migrated between
> > cpus at any time, the usage is:
> >
> > get_countext_switch_count (in cpu A)
> > do_something (in cpu B)
> > get_countext_switch_count (in cpu C)
> >
> > The cpu A, B, C could be completely different. We want to make sure
> > there is no preemption here and we use the context switch count to judge
> > this. If the high bits is ignored, the context switch count could be
> > identical even A != C, then our judgement using the switch count is
> > wrong.
> 
> Sure, but you could compare the cpu numbers, too.

Aha, makes sense.

Thanks,
Shaohua
