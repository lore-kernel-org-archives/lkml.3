Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbaGDX7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:59:14 -0400
Received: from mail.eperm.de ([89.247.134.16]:47161 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbaGDX7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 19:59:13 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] DRBG: Fix format string for debugging statements
Date: Sat, 05 Jul 2014 01:57:50 +0200
Message-ID: <3856718.HehN4Xqlpl@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.9-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1404493040.6384.21.camel@joe-AO725>
References: <4927386.WYHrRe3NJm@myon.chronox.de> <20140704112116.GC25934@mwanda> <1404493040.6384.21.camel@joe-AO725>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 4. Juli 2014, 09:57:20 schrieb Joe Perches:

Hi Joe,

> On Fri, 2014-07-04 at 14:21 +0300, Dan Carpenter wrote:
> > On Sat, Jun 28, 2014 at 08:53:19PM -0700, Joe Perches wrote:
> > > On Sun, 2014-06-29 at 05:46 +0200, Stephan Mueller wrote:
> > > > Am Sonntag, 29. Juni 2014, 12:24:02 schrieb Stephen Rothwell:
> > > > 
> > > > Hi Stephen,
> > > > 
> > > > > Hi Stephan,
> > > > > 
> > > > > On Sat, 28 Jun 2014 22:01:46 +0200 Stephan Mueller
> > > > > <smueller@chronox.de>
> > > > 
> > > > wrote:
> > > > > > @@ -1987,8 +1987,9 @@ static int __init drbg_init(void)
> > > > > > 
> > > > > >  	if (ARRAY_SIZE(drbg_cores) * 2 > ARRAY_SIZE(drbg_algs)) {
> > > > > >  	
> > > > > >  		pr_info("DRBG: Cannot register all DRBG types"
> > > > > > 
> > > > > > -			"(slots needed: %lu, slots available: %lu)\n",
> > > > > > -			ARRAY_SIZE(drbg_cores) * 2, 
ARRAY_SIZE(drbg_algs));
> > > > > > +			"(slots needed: %u, slots available: %u)\n",
> > > > > > +			(unsigned int)ARRAY_SIZE(drbg_cores) * 2,
> > > > > > +			(unsigned int)ARRAY_SIZE(drbg_algs));
> > > > > 
> > > > > Doesn't ARRAY_SIZE() always return a size_t?  In which case surely
> > > > > we
> > > > > need no casts, but need to us %zu in the format string.
> > > > 
> > > > Unfortunately not at all. On my x86_64, I get the compiler warning
> > > > that
> > > > ARRAY_SIZE is a long unsigned int without the cast.
> 
> It doesn't seem to for 4.8.
> Is there some specific gcc version where this occurs?

$ LANG=en_US gcc -v
Using built-in specs.
COLLECT_GCC=/usr/bin/gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.8.3/lto-wrapper
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --
infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --
enable-bootstrap --enable-shared --enable-threads=posix --enable-
checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-
exceptions --enable-gnu-unique-object --enable-linker-build-id --with-linker-
hash-style=gnu --enable-languages=c,c++,objc,obj-c++,java,fortran,ada,go,lto 
--enable-plugin --enable-initfini-array --enable-java-awt=gtk --disable-dssi 
--with-java-home=/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre --enable-libgcj-
multifile --enable-java-maintainer-mode --with-ecj-
jar=/usr/share/java/eclipse-ecj.jar --disable-libjava-multilib --with-
isl=/builddir/build/BUILD/gcc-4.8.3-20140624/obj-x86_64-redhat-linux/isl-
install --with-cloog=/builddir/build/BUILD/gcc-4.8.3-20140624/obj-x86_64-
redhat-linux/cloog-install --with-tune=generic --with-arch_32=i686 --
build=x86_64-redhat-linux
Thread model: posix
gcc version 4.8.3 20140624 (Red Hat 4.8.3-1) (GCC)

Note, I get a warning when compiling 64 bit with %u and without the unsigned 
int cast. Initially I had %lu without the cast which worked on my x86_64, but 
it was reported that this usage caused a warning on 32 bit. So, there is a 
different type of ARRAY_SIZE.

> I get the same output types and error warnings compiling this
> either -m32 or -m64

I do not get a warning for the ARRAY_SIZE thing with your code with either -
m32 or -m64 (I get other warnings though, which should not be of interest 
here).

And I also get the same output. Yet I am not sure how that code can be 
compared to the code in the kernel.

-- 
Ciao
Stephan
