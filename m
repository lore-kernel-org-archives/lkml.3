Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaIJTlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:41:07 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:31875 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaIJTlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:41:05 -0400
X-Greylist: delayed 93939 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 15:41:05 EDT
Message-ID: <1410377428.28990.260.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 2/6] x86, mm, pat: Change reserve_memtype() to handle
 WT
From: Toshi Kani <toshi.kani@hp.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Yigal Korman <yigal@plexistor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 10 Sep 2014 13:30:28 -0600
In-Reply-To: <CALCETrXRjU3HvHogpm5eKB3Cogr5QHUvE67JOFGbOmygKYEGyA@mail.gmail.com>
References: <1410367910-6026-1-git-send-email-toshi.kani@hp.com>
	 <1410367910-6026-3-git-send-email-toshi.kani@hp.com>
	 <CALCETrXRjU3HvHogpm5eKB3Cogr5QHUvE67JOFGbOmygKYEGyA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 11:26 -0700, Andy Lutomirski wrote:
> On Wed, Sep 10, 2014 at 9:51 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> > This patch changes reserve_memtype() to handle the WT cache mode.
> > When PAT is not enabled, it continues to set UC- to *new_type for
> > any non-WB request.
> >
> > When a target range is RAM, reserve_ram_pages_type() fails for WT
> > for now.  This function may not reserve a RAM range for WT since
> > reserve_ram_pages_type() uses the page flags limited to three memory
> > types, WB, WC and UC.
> 
> Should it fail if WT is unavailable due to errata?  More generally,
> how are all of the do_something_wc / do_something_wt /
> do_something_nocache helpers supposed to handle unsupported types?

When WT is unavailable due to the PAT errata, it does not fail but gets
redirected to UC-.  Similarly, when PAT is disabled, WT gets redirected
to UC- as well.

The failure case above is a run-time error when WT is enabled and is
targeted to RAM.  In this case, reserve_memtype() fails and sets UC- to
*new_type due to the limitation in page tables.  set_memory_xzy()
interfaces do not retry with new_type, but return an error.  I think
this makes sense since the caller should receive this error as this case
is a bug in the code (while running it on an old system is not a bug).

Thanks,
-Toshi


