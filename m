Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbbANVDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:03:48 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4220 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752008AbbANVDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:03:46 -0500
Date: Wed, 14 Jan 2015 13:03:26 -0800
From: Calvin Owens <calvinowens@fb.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-kernel <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC][PATCH] procfs: Add /proc/<pid>/mapped_files
Message-ID: <20150114210326.GA25159@mail.thefacebook.com>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
 <87oaq1v49z.fsf@rasmusvillemoes.dk>
 <CAAHN_R0AhAc7zt3sfbKdXJEj3Ncd4Hao-1qr=X3mkSjB7F_fYg@mail.gmail.com>
 <87fvbdv2g3.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <87fvbdv2g3.fsf@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-14_05:2015-01-14,2015-01-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.165369342820785 urlsuspect_oldscore=0.165369342820785
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.165369342820785 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501140205
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01/14 at 15:53 +0100, Rasmus Villemoes wrote:
> On Wed, Jan 14 2015, Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com> wrote:
> 
> > On 14 January 2015 at 19:43, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
> >> Just thinking out loud: Could one simply mark a VMA as being used for
> >> stack during the clone call (is there room in vm_flags, or does
> >> VM_GROWSDOWN already tell the whole story?), and then write the TID into
> >> a new field in the VMA - I think one could make a union with vm_pgoff so
> >> as not to enlarge the structure.
> >
> > vm_flags does not have space IIRC (that was my first approach at
> > implementing this) and VM_GROWSDOWN is not sufficient.
> 
> Looking at include/linux/mm.h:
> 
> #define VM_GROWSDOWN    0x00000100      /* general info on the segment */
> #define VM_PFNMAP       0x00000400      /* Page-ranges managed without "struct page", just pure PFN */
> #define VM_DENYWRITE    0x00000800      /* ETXTBSY on write attempts.. */
> 
> It would seem that 0x00000200 is available (unless defined and used
> somewhere else).
> 
> > If we can make a union with vm_pgoff like you say, we probably don't
> > need a flag value; a non-zero value could indicate that it is a thread
> > stack.
> 
> Well, only when combined with checking vm_file for being NULL. One would
> also need to ensure that vm_pgoff is 0 for any non-stack,
> non-file-backed VMA. At which point it is somewhat ugly. 
> 
> > One problem with caching the value on clone like this though is that
> > the stack could change due to a setcontext, but AFAICT we don't care
> > about that for the process stack either.
> 
> If it is important, I guess one could update the info when a task calls
> setcontext.

If I understand the current behavior, the "[stack]" marker will get put
next to *any* mapping that encompasses the current value in the task's
%sp, regardless of how the mapping was created or ucontext stuff. If
you use flags on the VMA structs things could potentially be marked as
stacks even though %sp points somewhere else.

It's probable that nobody cares (you'd obviously have to be doing crazy
things to be pointing %sp at arbitrary places), but that's why I was
hesitant to mess with it.

Thanks,
Calvin
 
> Rasmus
