Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3DVU6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:58:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2195 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab3DVU6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:58:23 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1tO4Y6a1dgIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=T6oyPw_TvikA:10 a=1XWaLZrsAAAA:8 a=lt4ytdTB0OJW7cPjzzsA:9 a=QEXdDO2ut3YA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366664301.9609.140.camel@gandalf.local.home>
Subject: Re: [PATCH] slab: Remove unnecessary __builtin_constant_p()
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux.com>,
        Behan Webster <behanw@converseincode.com>
Date: Mon, 22 Apr 2013 16:58:21 -0400
In-Reply-To: <20130422134415.32c7f2cac07c924bff3017a4@linux-foundation.org>
References: <1366225776.8817.28.camel@pippen.local.home>
	 <alpine.DEB.2.02.1304171702380.24494@chino.kir.corp.google.com>
	 <20130422134415.32c7f2cac07c924bff3017a4@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-22 at 13:44 -0700, Andrew Morton wrote:
> On Wed, 17 Apr 2013 17:03:21 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
> 
> > On Wed, 17 Apr 2013, Steven Rostedt wrote:
> > 
> > > The slab.c code has a size check macro that checks the size of the
> > > following structs:
> > > 
> > > struct arraycache_init
> > > struct kmem_list3
> > > 
> > > The index_of() function that takes the sizeof() of the above two structs
> > > and does an unnecessary __builtin_constant_p() on that. As sizeof() will
> > > always end up being a constant making this always be true. The code is
> > > not incorrect, but it just adds added complexity, and confuses users and
> > > wastes the time of reviewers of the code, who spends time trying to
> > > figure out why the builtin_constant_p() was used.
> > > 
> > > This patch is just a clean up that makes the index_of() code a little
> > > bit less complex.
> > > 
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > Acked-by: David Rientjes <rientjes@google.com>
> > 
> > Adding Pekka to the cc.
> 
> I ducked this patch because it seemed rather pointless - but a little
> birdie told me that there is a secret motivation which seems pretty
> reasonable to me.  So I shall await chirp-the-second, which hopefully
> will have a fuller and franker changelog ;)

<little birdie voice>
The real motivation behind this patch was it prevents LLVM (Clang) from
compiling the kernel. There's currently a bug in Clang where it can't
determine if a variable is constant or not, so instead, when
__builtin_constant_p() is used, it just treats it like it isn't a
constant (always taking the slow *safe* path).

Unfortunately, the "confusing" code of slub.c that unnecessarily uses
the __builtin_constant_p() will fail to compile if the variable passed
in is not constant. As Clang will say constants are not constant at this
point, the compile fails.

When looking into this, we found the only two users of the index_of()
static function that has this issue, passes in size_of(), which will
always be a constant, making the check redundant.

Note, this is a bug in Clang that will hopefully be fixed soon. But for
now, this strange redundant compile time check is preventing Clang from
even testing the Linux kernel build.
</little birdie voice>

And I still think the original change log has rational for the change,
as it does make it rather confusing to what is happening there.

-- Steve



