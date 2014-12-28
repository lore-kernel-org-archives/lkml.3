Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaL1Wsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 17:48:39 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:43714 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaL1Wsf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 17:48:35 -0500
MIME-Version: 1.0
In-Reply-To: <20141224234144.GA19262@amd>
References: <CAL82V5NN8U4PyiSjLxgpTrgsgkbM7rRCbVF5P-HHyEqphLOy+g@mail.gmail.com>
 <20141224234144.GA19262@amd>
From: Mark Seaborn <mseaborn@chromium.org>
Date: Sun, 28 Dec 2014 14:48:13 -0800
X-Google-Sender-Auth: 9cMw0JhpqTOpKfRR66HCdPumxkc
Message-ID: <CAL82V5OK0OQsxYsZ2hAMOP37wv_k7Jc9_zREUo_Pix1aZ0D6bQ@mail.gmail.com>
Subject: Re: DRAM unreliable under specific access patern
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, luto <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 December 2014 at 15:41, Pavel Machek <pavel@ucw.cz> wrote:
> > Try this test program: https://github.com/mseaborn/rowhammer-test
> >
> > It has reproduced bit flips on various machines.
...
> So we have a program that corrupts basically random memory on many
> machines. That is not good. That means that unpriviledged user can
> crash processes of other users.
...
> We could make DRAM refresh faster. That will incur performance
> penalty (<10%?), and is probably chipset-specific...?

Some machines already double the DRAM refresh rate in some cases.

For example, a presentation from Intel says:

  "When non-pTRR compliant DIMMs are used, the E5-2600 v2 system
  defaults into double refresh mode, which has longer memory
  latency/DIMM access latency and can lower memory bandwidth by up to
  2-4%.
  ...
  * DDR3 DIMMs are affected by a pass gate charge migration issue (also
    known as Row Hammer) that may result in a memory error.
  * The Pseudo Target Row Refresh (pTRR) feature introduced on Ivy
    Bridge processor families (2S/4S E5 v2, E7 v2) helps mitigate the
    DDR3 pass gate issue by automatically refreshing victim rows."

  -- from http://infobazy.gda.pl/2014/pliki/prezentacje/d2s2e4-Kaczmarski-Optymalna.pdf
  ("Thoughts on Intel Xeon E5-2600 v2 Product Family Performance
Optimisation – component selection guidelines", August 2014, Marcin
Kaczmarski)

Note that Target Row Refresh (TRR) is a DRAM feature that was added to
the recently-published LPDDR4 standard (where "LP" = "Low Power").
See http://www.jedec.org/standards-documents/results/jesd209-4
(registration is required to download the spec, but it's free).  TRR
is basically a request that the CPU's memory controller can send to a
DRAM module to ask it to refresh a row's neighbours.  I am not sure
how Pseudo TRR differs from TRR, though.

That presentation mentions one CPU (or CPU family), but I don't know
which other CPUs support these features (i.e. doubling the refresh
rate and/or using pTRR).  Even if a CPU supports these features, it is
difficult to determine whether a machine's BIOS enables them.  It is
the BIOS's responsibility to configure the CPU's memory controller at
startup.

Also, it is not clear how much doubling the DRAM refresh rate would
help prevent rowhammer-induced bit flips.  Yoongu Kim et al's paper
shows that, for some DRAM modules, a refresh period of 32ms (instead
of the usual 64ms) is not short enough to reduce the error rate to
zero.  See Figure 4 in
http://users.ece.cmu.edu/~yoonguk/papers/kim-isca14.pdf.  I expect
that doubling the refresh rate is useful for reliability, but not
necessarily security.  It would prevent accidental bit flips caused by
accidental row hammering, where programs accidentally generate a lot
of cache misses without using CLFLUSH.  But it might not prevent a
determined attacker from generating bit flips that might be used for
taking control of a system.

Cheers,
Mark
