Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab3FFGfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 02:35:23 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:51263 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab3FFGfW convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 6 Jun 2013 02:35:22 -0400
Message-Id: <51B049C702000078000DBC1A@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 06 Jun 2013 07:35:19 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Mukesh Rathor" <mukesh.rathor@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] PVH: vcpu info placement, load
 selectors, and remove debug printk.
References: <1370306612-12984-1-git-send-email-mukesh.rathor@oracle.com>
 <51ADC0F702000078000DAF5A@nat28.tlf.novell.com>
 <20130604145304.117ac60f@mantra.us.oracle.com>
 <51AEFED002000078000DB542@nat28.tlf.novell.com>
 <20130605121706.3a8211d6@mantra.us.oracle.com>
In-Reply-To: <20130605121706.3a8211d6@mantra.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.06.13 at 21:17, Mukesh Rathor <mukesh.rathor@oracle.com> wrote:
> On Wed, 05 Jun 2013 08:03:12 +0100
> "Jan Beulich" <JBeulich@suse.com> wrote:
> 
>> >>> On 04.06.13 at 23:53, Mukesh Rathor <mukesh.rathor@oracle.com>
>> >>> wrote:
>> > Following OK? :
>> > 
>> >         if (xen_feature(XENFEAT_auto_translated_physmap)) {
>> >                 switch_to_new_gdt(0);
>> > 
>> >                 asm volatile (
>> >                         "pushq %%rax\n"
>> >                         "leaq 1f(%%rip),%%rax\n"
>> >                         "pushq %%rax\n"
>> >                         "lretq\n"
>> >                         "1:\n"
>> >                         : : "a" (__KERNEL_CS) : "memory");
>> > 
>> >                 return;
>> >         }
>> 
>> While generally the choice of using %%rax instead of %0 here is
>> a matter of taste to some degree, I still don't see why you can't
>> use "r" as the constraint here in the first place.
> 
> The compiler mostly picks eax anyways, but good suggestion.
> 
>> Furthermore, assuming this sits in a function guaranteed to not be
>> inlined, this has a latent bug (and if the assumption isn't right, the
>> bug is real) in that the asm() modifies %rax without telling the
>> compiler.
> 
> According to one of the unofficial asm tutorials i've here, the compiler
> knows since it's input and doesn't need to be told. In fact
> it'll barf if added to clobber list.

No, if a tutorial says something like this, it's plain wrong. The
compiler does, as we know, occasionally re-use an unaltered
input in subsequent code (see the hypervisor change
http://xenbits.xen.org/gitweb/?p=xen.git;a=commitdiff;h=84628ee52a427b0f0fe50502eb8ffd0eedad0f03
for a case where this actually caused very bad problems in
practice).

Adding a register to the clobber list that's among the inputs and/or
outputs of course won't work, because it being on the clobber list
means the compiler must not use it _at all_ for any of its own
purposes. That's why you need - in the case here - a dummy output.

Jan

