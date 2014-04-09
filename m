Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbaDIASu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:18:50 -0400
Received: from nikam.ms.mff.cuni.cz ([195.113.20.16]:46955 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572AbaDIASt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:18:49 -0400
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2014 20:18:48 EDT
Date: Wed, 9 Apr 2014 02:10:13 +0200
From: Jan Hubicka <hubicka@ucw.cz>
To: Andi Kleen <ak@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hubicka@ucw.cz, jmario@redhat.com, mliska@suse.cz, vmakarov@redhat.com,
        markus@trippelsdorf.de, tglek@mozilla.com
Subject: Re: [GIT] kbuild/lto changes for 3.15-rc1
Message-ID: <20140409001013.GB8795@kam.mff.cuni.cz>
References: <20140407201919.GA15838@sepie.suse.cz>
 <CA+55aFy8hWqBpF1TXOPvA2rRaZp=H2LTO3wd3AERspmcGZhAeQ@mail.gmail.com>
 <20140408224926.GY32556@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408224926.GY32556@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Linus,
> 
> > So right now, I see several reasons not to merge it ("It's so
> > experimental that we don't even want to encourage people to test it"
> 
> I don't want them to enable it during allyesconfig because they
> might need more than 4GB of RAM to build it (especially with gcc 
> 4.8, 4.9 is better). But allyesconfig is a special case. More standard
> kernels with smaller vmlinux don't have this problem, but build
> somewhat slower.
> 
> > to "it's not fully fleshed out yet and makes compile times _much_
> > longer").
> 
> It's functionally stable, I have a number of users who
> don't report any problems.
> 
> > 
> > And yet nobody has actually talked about why I *should* merge it.
> > 
> > Which - I think understandably - makes me less than enthusiastic.
> > 
> > So I think I'll let this wait a bit longer, _unless_ people start
> > talking about the upsides. How much smaller is the end result? How
> > much faster is it? How much more beautiful is it? Does it make new
> 
> The smaller part is mainly visible with small kernels, because
> it's very good at throwing out unused code there.  All the
> stuff in kernel etc. that is not used.
> 
> For example Tim Bird saw ~11% binary reduction on ARM with his 
> configs [1]. We also see some reduction in small configs.
> 
> Some of the static measures like nice, for example
> a LTO kernel has ~4% less calls.
> 
> We did some performance tests, but at least in the standard
> macro benchmarks we do there wasn't a clear performance
> win.  LKP had a small win, but nothing dramatic.
> But I would like others to test it on their workloads.
> 
> In principle LTO can do cool optimizations, like propagating
> constants into functions (e.g. generate specialized versions
> of some code). I experimented a bit with this, however
> it currently seems to bloat the code quite a bit.
> 
> There are some other possible future optimizations
> that can be enabled by a global optimizer.
> 
> Honza may have more reasons for LTO.

My basic understanding of LTO benefits is about the following.

 1) Today LTO will quite reliably reduce code size. 
    Andi mentione 11% of kernel. It is not that unusual to get over 30% code
    size reduction.

    Generally it is a lot easier to fine tune hot spots than to throw away all
    unnecesary code in all possible configurations your project might have 
    (+ optimize by hand code layout).  So even well hand optimized programs
    benefits from LTO in code size.

 2) If build machinery is well structured, code size reduction also translates
    to compile time improvements (GCC spends a lot of time in codegen).
    This holds only for full rebuild (not compile/edit cycle) and only for
    projects that do not rebuild one binary many times (like both kernel and
    GCC does) or do not link many times large LTO library (like Firefox).

    For SPEC2k6, the LTO build time is faster, for Firefox it is about the same
    For GCC the bootstrap time is slower since our build system needs reorg (we
    use old libtool that requires fat LTO files and we rebuild every binary
    twice just to get a checksum, we also link whole backend as static library
    to every frontend binary) 

    I hope that not in too distant future we will be able to build majority of
    distro with LTO and get LTO build times better than non-LTO.
    I also have some longer term plans for compile-edit development model that
    won't trigger reoptimization of whole binary, but that is bit more of
    research stage right now.

 3) On really large projects, LTO may need a lot of memory.
    This is basically problem of kernel/firefox and chromium. Notihng else
    on my installation has similarly large binary.  We are improving this from
    release to release and I believe 4.9 is doing pretty well so I can build
    those things on my 8GB laptop w/o swap storms.

 4) LTO brings noticeable performance wins on average, but it is largely benchmark
    dependent; some see huge improvemnts, others no improvements at all.

    Basic observation is there is not much that LTO can do that can not be done
    by hand.  Careful developer can just identify the important spot and
    restructure the soruces.
    The runtime benefits are more visible on bigger, bloated and less
    optimized projects than on hand tuned video encoder implementation.
    I believe Kernel largely falls into hand tuned category despite its size.

    I am in progress of trying to benchmark GCC 4.9 LTO for Firefox/Libreoffice
    and Chromium and will publish once it is done.
    Just as very quick data point (not too serious) I just run Dromaeo
    benchmarks on firefox comparing default and LTO build, the overall
    difference is 7% http://dromaeo.com/?id=219677,219678,219672,219676
    (first two tests are default build, second two are LTO).
    This is a lot more than I expected given that dromaeo tests largery JIT
    generated code and I am sure it is a common benchmark well hand optimized.

    Vladimir has some SPEC2k scores http://vmakarov.fedorapeople.org/spec/
    and in a brief summary at http://vmakarov.fedorapeople.org/spec/peak.html

    I would be curious about the results on Kernel.

 5) LTO combine very well with profile feedback directed optimization (FDO). 
    One of problem of compiler (and compiler developer) is what to do with
    all the extra freedom one suddenly gets.  FDO really helps.

    GCC 4.9 will optimize code layout with FDO (something Martin
    Liska implemented based on Taras Glek's analysis) and do a lot better
    inlining than without.
    I hope the static code (without FDO) layout will also get better in relese
    after 4.9.  This makes programs to start measurably faster and touch less
    pages. http://arxiv.org/pdf/1403.6997.pdf

 6) LTO will pay back more in long term.

    It is not only because LTO implementation in GCC (and LLVM) has more room
    for improvement than the per-file optimizers.

    Main things is that despite the aim to be transparent to user,
    LTO is invasive change.  Existing programs was developed and tuned for
    per-file optimization model and many of them contains a lot of hacks to
    work around its limitation (such as a lot of inline code in headers, etc.)
    With LTO becoming mainstream, developers will have time to work on different
    hacks ;)

    I also believe that in addition to optimization, we will see more static
    analysis built around in future.

In 2010 I started working on project making large apps working with GCC LTO
(http://arxiv.org/pdf/1010.2196.pdf). It is a long run to a moving target.
I am very happy Andi did the hard work on getting Kernel work and would like
to see the patches upstream. There are measurable improvements now and more
users we get, the faster will LTO improve.

Honza
> 
> Other benefits are global warnings and some additional
> type checking. The LTO log files are really useful
> to do global call graph analysis and similar.
> 
> -Andi
> 
> [1] http://elinux.org/images/9/9e/Bird-Kernel-Size-Optimization-LCJ-2013.pdf
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only
