Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbaE3IuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:50:00 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:53545 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbaE3It4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:49:56 -0400
Date: Fri, 30 May 2014 10:49:26 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johan Hovold <jhovold@gmail.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, dirk.j.brandewie@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Smythies <dsmythies@telus.net>, Yuyang Du <yuyang.du@intel.com>,
        Stratos Karafotis <stratosk@semaphore.gr>
Subject: Re: Performance regression in v3.14
Message-ID: <20140530084926.GA2044@localhost>
References: <20140506163559.GA5308@localhost>
 <CAKohpokYEvazxm0-JJXPzq-4OgLXmROfaCMcgHDZwugChOxtsQ@mail.gmail.com>
 <536A3EE9.5050409@intel.com>
 <20140521090051.GO21412@localhost>
 <20140528075945.GA21705@localhost>
 <20140530022734.GC19080@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530022734.GC19080@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 07:27:34PM -0700, Greg Kroah-Hartman wrote:
> On Wed, May 28, 2014 at 09:59:45AM +0200, Johan Hovold wrote:
> > [ +CC: Greg, Doug, Stratos, Yuyang ]
> > 
> > On Wed, May 21, 2014 at 11:00:51AM +0200, Johan Hovold wrote:
> > > On Wed, May 07, 2014 at 07:10:49AM -0700, Dirk Brandewie wrote:
> > > > On 05/06/2014 10:40 PM, Viresh Kumar wrote:
> > > > > Cc'ing Dirk who is taking care of intel-pstate driver.
> > > > >
> > > > 
> > > > Thanks Viresh I had seen this thread.
> > > > 
> > > > I am looking into it
> > > 
> > > Any updates on this, Dirk? 3.14 is still basically unusable with the
> > > intel_pstate driver.
> > > 
> > > Any fixes or workarounds posted elsewhere that I can apply in the
> > > meantime?
> > 
> > Another week and still no reply, Dirk?
> > 
> > I tried applying your (rejected) patch "intel_pstate: Remove C0
> > tracking" posted here:
> > 
> > 	https://lkml.org/lkml/2014/5/8/574
> > 
> > to v3.14.4 and it fixes the problem as expected.
> > 
> > So we have a commit fcb6a15c2e7e ("intel_pstate: Take core C0 time into
> > account for core busy calculation") that went into v3.14-rc2 (and was
> > even marked for *stable*) that first broke Greg KH's system:
> > 
> > 	https://lkml.org/lkml/2014/2/19/626
> > 
> > That was apparently fixed by e66c17683746 ("intel_pstate: Change
> > busy calculation to use fixed point math."), but still left v3.14
> > basically unusable for lower-intensity workloads such as my
> > bash-completion example and other reported regressions:
> > 
> > 	https://bugzilla.kernel.org/show_bug.cgi?id=75121
> > 
> > Sure there may be issues with v3.13 not hitting the lowest frequencies
> > but at least the system was *usable*.
> > 
> > In my opinion there's really no other option than to restore the 3.13
> > behaviour by effectively reverting fcb6a15c2e7e ("intel_pstate: Take
> > core C0 time into account for core busy calculation") until you have
> > figured out a way to take C0 into account without breaking things too
> > badly.
> 
> Dirk has posted some patches, do they fix the problem for you?

Thanks for letting me know.

As the series posted yesterday includes the effective revert
"intel_pstate: Remove C0 tracking" mentioned above, they do.  

The series does not apply at all to v3.14.4, and I choose to include
d37e2b764499 ("intel_pstate: remove unneeded sample buffers") in order
to ease backporting slightly.

I don't see much difference from applying only the revert patch or all
of them. I've included turbostat output from when running my
bash-construct on an idle system (running X, though) below.

With 3.14.4 all cores appear stuck at minimum frequency. With the
revert patch (with or without the remaining patches) frequencies are
around 3.7Ghz for all cores.

As at least one of the new patches has already raised some discussion:

	http://marc.info/?l=linux-pm&m=140141648726863&w=2

perhaps we should consider simply applying and backporting the revert
(and fixed-point rounding fix) to restore v3.13 behaviour and un-break
v3.14 in the meantime?

Thanks,
Johan


v3.14.4 (with "intel_pstate: Remove C0 tracking" and a version of
"intel_pstate: Fix fixed point rounding macro" from two weeks ago):

cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6    %c7 CTMP PTMP   %pc2   %pc3   %pc6   %pc7  Pkg_W  Cor_W GFX_W
         12.63 3.88 3.39   0  13.32   0.02   0.06  73.96   41   41   0.00   0.00   0.00   0.00  18.69  10.70  0.00
  0   0   0.50 3.88 3.39   0   3.28   0.10   0.24  95.88   31   41   0.00   0.00   0.00   0.00  18.69  10.70  0.00
  0   4   0.57 3.87 3.39   0   3.22
  1   1   0.09 3.61 3.39   0   0.03   0.00   0.00  99.88   31
  1   5   0.01 3.74 3.39   0   0.11
  2   2   0.02 3.61 3.39   0   0.02   0.00   0.00  99.96   31
  2   6   0.01 3.80 3.39   0   0.04
  3   3  99.85 3.89 3.39   0   0.04   0.00   0.00   0.12   41
  3   7   0.01 3.81 3.39   0  99.87
1.194291 sec

v3.14.4 (with patches from yesterday):

cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6    %c7 CTMP PTMP   %pc2   %pc3   %pc6   %pc7  Pkg_W  Cor_W GFX_W
         12.63 3.88 3.39   0  13.33   0.04   0.04  73.95   44   45   0.00   0.00   0.00   0.00  18.65  10.70  0.00
  0   0   0.52 3.88 3.39   0   3.28   0.17   0.16  95.88   33   45   0.00   0.00   0.00   0.00  18.65  10.70  0.00
  0   4   0.58 3.87 3.39   0   3.22
  1   1   0.10 3.45 3.39   0   0.05   0.00   0.00  99.85   34
  1   5   0.01 3.67 3.39   0   0.14
  2   2   0.02 3.56 3.39   0   0.04   0.00   0.00  99.94   34
  2   6   0.01 3.63 3.39   0   0.05
  3   3  99.82 3.89 3.39   0   0.05   0.00   0.00   0.13   44
  3   7   0.01 3.70 3.39   0  99.86
1.197190 sec

v3.14.4 (current stable):

cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6    %c7 CTMP PTMP   %pc2   %pc3   %pc6   %pc7  Pkg_W  Cor_W GFX_W
         12.86 0.82 3.39   0  14.16   0.00   0.00  72.97   32   32   0.00   0.00   0.00   0.00   5.55   0.61  0.00
  0   0   2.26 0.82 3.39   0   5.74   0.01   0.02  91.98   32   32   0.00   0.00   0.00   0.00   5.55   0.61  0.00
  0   4   0.58 0.82 3.39   0   7.42
  1   1   0.09 0.82 3.39   0   0.03   0.00   0.00  99.88   31
  1   5   0.01 0.85 3.39   0   0.10
  2   2   0.02 0.83 3.39   0   0.06   0.00   0.00  99.92   31
  2   6   0.03 0.86 3.39   0   0.05
  3   3  99.89 0.82 3.39   0   0.01   0.00   0.00   0.09   31
  3   7   0.02 0.89 3.39   0  99.89
5.675564 sec
