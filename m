Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaASDcP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 22:32:15 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:45790 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbaASDcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 22:32:12 -0500
MIME-Version: 1.0
In-Reply-To: <1389013441-28893-1-git-send-email-prarit@redhat.com>
References: <1389013441-28893-1-git-send-email-prarit@redhat.com>
Date: Sat, 18 Jan 2014 22:32:11 -0500
X-Google-Sender-Auth: XqfdcGECj8GgMm3YgNCu-Z3dvlI
Message-ID: <CAJvTdKnAF=D2Qyda=vW7ZBBnyZw8eFbvvwskD03abSDkiNjrzQ@mail.gmail.com>
Subject: Re: [PATCH] x86 turbostat, replace numa based core ID with physical ID
From: Len Brown <lenb@kernel.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK

On Mon, Jan 6, 2014 at 8:04 AM, Prarit Bhargava <prarit@redhat.com> wrote:
> Len, here are some test results.
>
> On a 2-socket AMD 6276 system with the existing turbostat I see
>
> pk cor CPU   GHz  TSC
>           0.74 1.15
> 0   0   8 1.48 2.30
> 0   1   9 1.48 2.30
> 0   2  10 1.53 2.30
> 0   3  11 1.46 2.30
> 0   4  12 1.49 2.30
> 0   5  13 1.47 2.30
> 0   6  14 1.48 2.30
> 0   7  15 1.54 2.30
> 1   0  24 1.49 2.30
> 1   1  25 1.48 2.30
> 1   2  26 1.48 2.30
> 1   3  27 1.51 2.30
> 1   4  28 1.52 2.30
> 1   5  29 1.43 2.30
> 1   6  30 1.51 2.30
> 1   7  31 1.49 2.30
>
> As you can see only 8 of each 16 cores are reported.  The issue is that the
> core_id sysfs file is not physical-based; it is numa-based and it may differ
> from that of the physical enumeration, especially in the cases where sockets
> are split by numa nodes.  It looks like we really want the physical core_id
> and not the numa core_id.  After the patch,
>
> pk cor CPU   GHz  TSC
>            1.47 2.30
>  0   0   0 1.46 2.30
>  0   1   1 1.44 2.30
>  0   2   2 1.51 2.30
>  0   3   3 1.49 2.30
>  0   4   4 1.51 2.30
>  0   5   5 1.51 2.30
>  0   6   6 1.49 2.30
>  0   7   7 1.49 2.30
>  0   8   8 1.47 2.30
>  0   9   9 1.48 2.30
>  0  10  10 1.64 2.30
>  0  11  11 1.54 2.30
>  0  12  12 1.51 2.30
>  0  13  13 1.46 2.30
>  0  14  14 1.49 2.30
>  0  15  15 1.46 2.30
>  1   0  16 1.49 2.30
>  1   1  17 1.44 2.30
>  1   2  18 1.51 2.30
>  1   3  19 1.44 2.30
>  1   4  20 1.50 2.30
>  1   5  21 1.44 2.30
>  1   6  22 1.50 2.30
>  1   7  23 1.44 2.30
>  1   8  24 1.48 2.30
>  1   9  25 1.46 2.30
>  1  10  26 1.47 2.30
>  1  11  27 1.49 2.30
>  1  12  28 1.52 2.30
>  1  13  29 1.43 2.30
>  1  14  30 1.51 2.30
>  1  15  31 1.45 2.30
>
> As a sanity check I also ran on a dual-socket E5-26XX v2 system:
>
> pk cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6    %c7 CTMP PTMP   %pc2   %pc3   %pc6   %pc7  Pkg_W  Cor_W RAM_W PKG_% RAM_%
>              0.04 1.30 2.69   0   0.12   0.00  99.84   0.00   32   32  12.28   0.00  86.59   0.00  11.20   2.74  6.48  0.00  0.00
>  0   0   0   0.23 1.20 2.69   0   0.43   0.00  99.34   0.00   26   27  12.39   0.00  86.61   0.00   5.76   1.53  1.85  0.00  0.00
>  0   0  20   0.05 1.21 2.69   0   0.61
>  0   1   1   0.02 1.23 2.69   0   0.08   0.00  99.90   0.00   26
>  0   1  21   0.02 1.26 2.69   0   0.08
>  0   2   2   0.02 1.29 2.69   0   0.06   0.00  99.92   0.00   25
>  0   2  22   0.02 1.35 2.69   0   0.06
>  0   3   3   0.02 1.28 2.69   0   0.06   0.00  99.92   0.00   25
>  0   3  23   0.02 1.35 2.69   0   0.06
>  0   4   4   0.03 1.25 2.69   0   0.06   0.00  99.90   0.00   32
>  0   4  24   0.02 1.33 2.69   0   0.08
>  0   9   5   0.02 1.35 2.69   0   0.05   0.00  99.93   0.00   28
>  0   9  25   0.02 1.34 2.69   0   0.05
>  0  10   6   0.02 1.25 2.69   0   0.05   0.00  99.93   0.00   21
>  0  10  26   0.02 1.34 2.69   0   0.05
>  0  11   7   0.02 1.29 2.69   0   0.06   0.00  99.92   0.00   32
>  0  11  27   0.02 1.35 2.69   0   0.06
>  0  12   8   0.02 1.27 2.69   0   0.06   0.00  99.92   0.00   31
>  0  12  28   0.02 1.33 2.69   0   0.06
>  0  13   9   0.02 1.25 2.69   0   0.05   0.00  99.93   0.00   20
>  0  13  29   0.02 1.30 2.69   0   0.06
>  1   0  10   0.04 1.23 2.69   0   0.10   0.00  99.86   0.00   29   32  12.16   0.00  86.59   0.00   5.45   1.22  4.63  0.00  0.00
>  1   0  30   0.03 1.20 2.69   0   0.11
>  1   1  11   0.04 1.20 2.69   0   0.10   0.00  99.86   0.00   30
>  1   1  31   0.03 1.20 2.69   0   0.11
>  1   2  12   0.03 1.20 2.69   0   0.08   0.00  99.89   0.00   29
>  1   2  32   0.02 1.20 2.69   0   0.09
>  1   3  13   0.21 1.20 2.69   0   0.11   0.00  99.68   0.00   29
>  1   3  33   0.03 1.20 2.69   0   0.30
>  1   4  14   0.04 1.20 2.69   0   0.08   0.00  99.88   0.00   31
>  1   4  34   0.02 1.20 2.69   0   0.10
>  1   9  15   0.03 1.20 2.69   0   0.08   0.00  99.88   0.00   26
>  1   9  35   0.02 1.20 2.69   0   0.10
>  1  10  16   0.03 1.20 2.69   0   0.08   0.00  99.89   0.00   28
>  1  10  36   0.02 1.20 2.69   0   0.09
>  1  11  17   0.03 1.20 2.69   0   0.08   0.00  99.89   0.00   26
>  1  11  37   0.02 1.20 2.69   0   0.09
>  1  12  18   0.33 1.44 2.69   0   0.09   0.00  99.58   0.00   25
>  1  12  38   0.02 1.20 2.69   0   0.40
>  1  13  19   0.11 1.74 2.69   0   0.10   0.00  99.79   0.00   31
>  1  13  39   0.03 1.20 2.69   0   0.17
>
> And after the patch,
>
> pk cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6    %c7 CTMP PTMP   %pc2   %pc3   %pc6   %pc7  Pkg_W  Cor_W RAM_W PKG_% RAM_%
>              0.04 1.22 2.69   0  50.05   0.00  99.83   0.00   33   32  12.29   0.00  86.75   0.00  11.33   2.73  6.35  0.00  0.00
>  0   0   0   0.14 1.21 2.69   0   0.34   0.00  99.53   0.00   26   27  12.43   0.00  86.77   0.00   5.83   1.53  1.92  0.00  0.00
>  0   1   1   0.02 1.24 2.69   0   0.06   0.00  99.92   0.00   26
>  0   2   2   0.02 1.29 2.69   0   0.09   0.00  99.90   0.00   26
>  0   3   3   0.02 1.31 2.69   0   0.09   0.00  99.89   0.00   24
>  0   4   4   0.03 1.27 2.69   0   0.11   0.00  99.87   0.00   33
>  0   5   5   0.02 1.30 2.69   0   0.10   0.00  99.88   0.00   28
>  0   6   6   0.02 1.25 2.69   0   0.08   0.00  99.90   0.00   21
>  0   7   7   0.02 1.22 2.69   0   0.09   0.00  99.89   0.00   32
>  0   8   8   0.02 1.26 2.69   0   0.10   0.00  99.88   0.00   31
>  0   9   9   0.02 1.30 2.69   0   0.08   0.00  99.90   0.00   21
>  0  20  20   0.04 1.23 2.69   0  99.96
>  0  21  21   0.02 1.30 2.69   0  99.98
>  0  22  22   0.02 1.34 2.69   0  99.98
>  0  23  23   0.02 1.33 2.69   0  99.98
>  0  24  24   0.02 1.28 2.69   0  99.98
>  0  25  25   0.02 1.27 2.69   0  99.98
>  0  26  26   0.02 1.34 2.69   0  99.98
>  0  27  27   0.02 1.33 2.69   0  99.98
>  0  28  28   0.02 1.29 2.69   0  99.98
>  0  29  29   0.02 1.31 2.69   0  99.98
>  1   0  30   0.02 1.20 2.69   0  99.98
>  1   1  31   0.03 1.20 2.69   0  99.97
>  1   2  32   0.02 1.20 2.69   0  99.98
>  1   3  33   0.03 1.20 2.69   0  99.97
>  1   4  34   0.02 1.20 2.69   0  99.98
>  1   5  35   0.02 1.20 2.69   0  99.98
>  1   6  36   0.02 1.20 2.69   0  99.98
>  1   7  37   0.02 1.20 2.69   0  99.98
>  1   8  38   0.02 1.20 2.69   0  99.98
>  1   9  39   0.02 1.20 2.69   0  99.98
>  1  10  10   0.05 1.20 2.69   0   0.13   0.00  99.82   0.00   29   32  12.16   0.00  86.74   0.00   5.50   1.21  4.43  0.00  0.00
>  1  11  11   0.03 1.20 2.69   0   0.14   0.00  99.83   0.00   29
>  1  12  12   0.40 1.20 2.69   0   0.11   0.00  99.49   0.00   30
>  1  13  13   0.03 1.20 2.69   0   0.12   0.00  99.85   0.00   29
>  1  14  14   0.03 1.20 2.69   0   0.09   0.00  99.88   0.00   32
>  1  15  15   0.03 1.20 2.69   0   0.10   0.00  99.87   0.00   27
>  1  16  16   0.03 1.20 2.69   0   0.10   0.00  99.86   0.00   29
>  1  17  17   0.03 1.20 2.69   0   0.11   0.00  99.86   0.00   28
>  1  18  18   0.03 1.20 2.69   0   0.09   0.00  99.88   0.00   26
>  1  19  19   0.04 1.20 2.69   0   0.10   0.00  99.86   0.00   30
>
> which AFAICT is correct.

This is erroneous.

The Xeon system above has 10 cores per package, each with 2 HT siblings.
But you have invented an additional 10 cores per package, and screwed
up turbostat's topology awareness.  It will now context switch to each
physical core twice instead of once to get per core counters.

I don't understand the AMD problem.
Apparently it repeats core_id's within the same package?
I'm baffled at why it would do that, and why it would not
be a bug in topology.c.

thanks,
Len Brown, Intel Open Source Technology Center
