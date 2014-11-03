Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaKCMLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:11:23 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:52972 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaKCMLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:11:21 -0500
Date: Mon, 3 Nov 2014 12:10:49 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org
Subject: Re: [PATCH v4 10/10] x86: Support compiling out userspace IO (iopl
 and ioperm)
Message-ID: <20141103121049.2f0c81a9@alan.etchedpixels.co.uk>
In-Reply-To: <ec10c497d3a7f44f335dbc267edd6de5b4acd671.1414870871.git.josh@joshtriplett.org>
References: <cover.1414870871.git.josh@joshtriplett.org>
	<ec10c497d3a7f44f335dbc267edd6de5b4acd671.1414870871.git.josh@joshtriplett.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Nov 2014 09:33:01 -0800
Josh Triplett <josh@joshtriplett.org> wrote:

> On the vast majority of modern systems, no processes will use the
> userspsace IO syscalls, iopl and ioperm.  Add a new config option,
> CONFIG_X86_IOPORT, to support configuring them out of the kernel
> entirely.  Most current systems do not run programs using these
> syscalls, so X86_IOPORT does not depend on EXPERT, though it does still
> default to y.

This isn't unreasonable but there are drivers with userspace helpers that
use iopl/ioperm type functionality where you should be doing a SELECT of
X86_IOPORT. The one that comes to mind is the uvesa driver. From a quick
scan it may these days be the only mainstream one that needs the select
adding.

Some X servers for legacy cards still use io port access. There are also
a couple of other highly non-obvious userspace users that hang on for
some systems - eg some older servers DMI and error records can only by
read via a real mode BIOS call so management tools have no choice but to
go the lrmi/io path.

Still makes sense IMHO.

>From a code perspective however you could define IO_BITMAP_LONGS to 0,
add an IO_BITMAP_SIZE (defined as LONGS + 1 or 0) and as far as I can see
gcc would then optimise out a lot of the code you are ifdeffing

Alan
