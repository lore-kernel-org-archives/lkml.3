Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaLPMxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 07:53:23 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:33387 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaLPMxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 07:53:20 -0500
MIME-Version: 1.0
In-Reply-To: <20141216113509.GI4856@mwanda>
References: <1418708509-18196-1-git-send-email-chris@rorvick.com>
	<20141216094109.GH4856@mwanda>
	<D0B55F56.D05F1%andreas.dilger@intel.com>
	<20141216113509.GI4856@mwanda>
Date: Tue, 16 Dec 2014 06:53:19 -0600
X-Google-Sender-Auth: H2gjMljjY5BrDQbnYtcxmNCeD5M
Message-ID: <CAEUsAPYTBq+0DGG909Rn0JhpF5Rh_6KbvmxS0wPQJ3j+qgZrEQ@mail.gmail.com>
Subject: Re: [PATCH] drivers: staging: lustre: Use mult if units not specified
From: Chris Rorvick <chris@rorvick.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Dilger, Andreas" <andreas.dilger@intel.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Fabian Frederick <fabf@skynet.be>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        James Simmons <uja.ornl@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Drokin, Oleg" <oleg.drokin@intel.com>,
        Greg Donald <gdonald@gmail.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        "HPDD-discuss@ml01.01.org" <HPDD-discuss@ml01.01.org>,
        "Hammond, John" <john.hammond@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 5:35 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Dec 16, 2014 at 11:14:35AM +0000, Dilger, Andreas wrote:
> >
> > Sorry, that isn't right.  Chris' patch is actually doing the right thing
> > to check for units > 1.
>
> It's not right because it discards the negative.

I don't think this patch introduces a bug.  If anything, it was already
there.  It looked to me like the value passed in to `mult' was assumed
to be positive and was simply being used as a flag to indicate whether
`buffer' started with a '-' when units were passed.

For example, say the value passed in is "-2K" and the `mult' is 1.  The
check for '-' will negate `mult' making it -1.  Then the units
conditional will override mult with `-units' (i.e., -1024.)

Now say we pass "-2" with `mult' equal to 1024.  The result is same, but
the path is a bit different.  `mult' will again be negated due to
`buffer' beginning with '-', but then it will be left alone at the units
check.

In both of the above cases the negative sign is properly accounted for.

> >  The proposed change above discards "mult"
> > entirely, which breaks the users of this function that are not in this
> > file (e.g. osc_cached_mb_seq_write() or ll_max_cached_mb_seq_write())
> > that have tunables in units of MB by default, but can also use parameters
> > with units like "4.5G" for convenience.
>
> I think you are confusing lprocfs_write_frac_helper() and
> lprocfs_write_frac_u64_helper().  There is only one caller for this
> function.

By this logic, lprocfs_write_frac_u64_helper() should just be removed
and it's code should be folded into lprocfs_write_u64_helper(), no?

Regards,

Chris
