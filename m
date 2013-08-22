Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3HVHyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:54:49 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:56686 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3HVHys convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Thu, 22 Aug 2013 03:54:48 -0400
Message-Id: <5215DFE302000078000ED8C6@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 22 Aug 2013 08:54:43 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andy Lutomirski" <luto@amacapital.net>
Cc: "David Vrabel" <david.vrabel@citrix.com>,
        "Cyrill Gorcunov" <gorcunov@gmail.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <Xen-devel@lists.xen.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Pavel Emelyanov" <xemul@parallels.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts
 with existing use
References: <5214C524.1050900@citrix.com>
 <CALCETrWZqGUC4+43VT54gFd8qAf+0o4Ekyq8dKVqYpuZOCR9qg@mail.gmail.com>
In-Reply-To: <CALCETrWZqGUC4+43VT54gFd8qAf+0o4Ekyq8dKVqYpuZOCR9qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.08.13 at 19:28, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Aug 21, 2013 at 6:48 AM, David Vrabel <david.vrabel@citrix.com> wrote:
>> All,
>>
>> 179ef71c (mm: save soft-dirty bits on swapped pages) introduces a new
>> PTE bit on x86 _PTE_SWP_SOFT_DIRTY which has the same value as _PTE_PSE
>> and _PTE_PAT.
>>
>> With a Xen PV guest, the use of the _PTE_PAT will result in the page
>> having unexpected cachability which will introduce a range of subtle
>> performance and correctness issues.  Xen programs the entry 4 in the PAT
>> table with WC so a page that was previously WB will end up as WC.
>>
> 
> Kind of off topic, but do you have a summary of how Xen uses the high
> PAT bits?  I'm the one who wants WT, and if there's already precedent
> for using the high PAT bits, it'll be helpful.

Xen's public headers have a comment explaining this, with the
main information being this table:

 *  The PAT MSR is as follow (it is a 64-bit value, each entry is 8 bits):
 *             PAT4                 PAT0
 *   +---+----+----+----+-----+----+----+
 *    WC | WC | WB | UC | UC- | WC | WB |  <= Linux
 *   +---+----+----+----+-----+----+----+
 *    WC | WT | WB | UC | UC- | WT | WB |  <= BIOS (default when machine boots)
 *   +---+----+----+----+-----+----+----+
 *    WC | WP | WC | UC | UC- | WT | WB |  <= Xen
 *   +---+----+----+----+-----+----+----+

i.e. Xen is retaining the BIOS (and legacy from non-PAT times)
meaning of the low four entries, putting WC and WP up into
the high half. The fact that the entry 6 is defined to be WC
is perhaps a mistake - it should really be considered reserved
for an eventual future memory type (just like entry 7). It also
seems like entry 6 is documented incorrectly here for Linux and
BIOS.

Jan

