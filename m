Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3J2Vd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:33:56 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:49892 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3J2Vdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:33:55 -0400
MIME-Version: 1.0
In-Reply-To: <20131029205756.GH9568@quack.suse.cz>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
	<CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
	<1814253454.3449.1382689853825.JavaMail.mail@webmail07>
	<20131025091842.GA28681@thunk.org>
	<20131025022937.12623dcd.akpm@linux-foundation.org>
	<CA+55aFzq4-wsErRO56gW6gj3Q91QtvvaGQPdUV2JkSs-B1PCAQ@mail.gmail.com>
	<20131029205756.GH9568@quack.suse.cz>
Date: Tue, 29 Oct 2013 14:33:53 -0700
X-Google-Sender-Auth: IdzdQ7_x3O9C2oYJdoFcZF2gZV0
Message-ID: <CA+55aFyS1oTF2LKSgmm_TnnKm18CfVZEaue8-EnPQWOikAUWOA@mail.gmail.com>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Content-Type: multipart/mixed; boundary=089e0122f0f22fad9404e9e7f948
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0122f0f22fad9404e9e7f948
Content-Type: text/plain; charset=UTF-8

On Tue, Oct 29, 2013 at 1:57 PM, Jan Kara <jack@suse.cz> wrote:
> On Fri 25-10-13 10:32:16, Linus Torvalds wrote:
>>
>> It definitely doesn't work. I can trivially reproduce problems by just
>> having a cheap (==slow) USB key with an ext3 filesystem, and going a
>> git clone to it. The end result is not pretty, and that's actually not
>> even a huge amount of data.
>
>   I'll try to reproduce this tomorrow so that I can have a look where
> exactly are we stuck. But in last few releases problems like this were
> caused by problems in reclaim which got fed up by seeing lots of dirty
> / under writeback pages and ended up stuck waiting for IO to finish. Mel
> has been tweaking the logic here and there but maybe it haven't got fixed
> completely. Mel, do you know about any outstanding issues?

I'm not sure this has ever worked, and in the last few years the
common desktop memory size has continued to grow.

For servers and "serious" desktops, having tons of dirty data doesn't
tend to be as much of a problem, because those environments are pretty
much defined by also having fairly good IO subsystems, and people
seldom use crappy USB devices for more than doing things like reading
pictures off them etc. And you'd not even see the problem under any
such load.

But it's actually really easy to reproduce by just taking your average
USB key and trying to write to it. I just did it with a random ISO
image, and it's _painful_. And it's not that it's painful for doing
most other things in the background, but if you just happen to run
anything that does "sync" (and it happens in scripts), the thing just
comes to a screeching halt. For minutes.

Same obviously goes with trying to eject/unmount the media etc.

We've had this problem before with the whole "ratio of dirty memory"
thing. It was a mistake. It made sense (and came from) back in the
days when people had 16MB or 32MB of RAM, and the concept of "let's
limit dirty memory to x% of that" was actually fairly reasonable. But
that "x%" doesn't make much sense any more. x% of 16GB (which is quite
the reasonable amount of memory for any modern desktop) is a huge
thing, and in the meantime the performance of disks have gone up a lot
(largely thanks to SSD's), but the *minimum* performance of disks
hasn't really improved all that much (largely thanks to USB ;).

So how about we just admit that the whole "ratio" thing was a big
mistake, and tell people that if they want to set a dirty limit, they
should do so in bytes? Which we already really do, but we default to
that ratio nevertheless. Which is why I'd suggest we just say "the
ratio works fine up to a certain amount, and makes no sense past it".

Why not make that "the ratio works fine up to a certain amount, and
makes no sense past it" be part of the calculations. We actually
*hace* exactly that on HIGHMEM machines, where we have this
configuration option of "vm_highmem_is_dirtyable" that defaults to
off. It just doesn't trigger on nonhighmem machines (today: "64-bit").

So I would suggest that we just expose that "vm_highmem_is_dirtyable"
on 64-bit too, and just say that anything over 1GB is highmem. That
means that 32-bit and 64-bit environments will basically act the same,
and I think it makes the defaults a bit saner.

Limiting the amount of dirty memory to 100MB/200MB (for "start
background writing" and "wait synchronously" respectively) even if you
happen to have 16GB of memory sounds like a good idea. Sure, it might
make some benchmarks a bit slower, but it will at least avoid the
"wait forever" symptom. And if you really have a very studly IO
subsystem, the fact that it starts writing out earlier won't really be
a problem.

After all, there are two reasons to do delayed writes:

 - temp-files may not be written out at all.

   Quite frankly, if you have multi-hundred-megabyte temptiles, you've
got issues

 - coalescing writes improves throughput

   There are very much diminishing returns, and the big return is to
make sure that we write things out in a good order, which a 100MB
buffer should make more than possible.

so I really think that it's insane to default to 1.6GB of dirty data
before you even start writing it out if you happen to have 16GB of
memory.

And again: if your benchmark is to create a kernel tree and then
immediately delete it, and you used to do that without doing any
actual IO, then yes, the attached patch will make that go much slower.
But for that benchmark, maybe you should just set the dirty limits (in
bytes) by hand, rather than expect the default kernel values to prefer
benchmarks over sanity?

Suggested patch attached. Comments?

                            Linus

--089e0122f0f22fad9404e9e7f948
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hndnkfpp0

IGtlcm5lbC9zeXNjdGwuYyAgICAgfCAyIC0tCiBtbS9wYWdlLXdyaXRlYmFjay5jIHwgNyArKysr
KystCiAyIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9rZXJuZWwvc3lzY3RsLmMgYi9rZXJuZWwvc3lzY3RsLmMKaW5kZXggYjJmMDZm
M2M2YTNmLi40MTFkYTU2Y2Q3MzIgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9zeXNjdGwuYworKysgYi9r
ZXJuZWwvc3lzY3RsLmMKQEAgLTE0MDYsNyArMTQwNiw2IEBAIHN0YXRpYyBzdHJ1Y3QgY3RsX3Rh
YmxlIHZtX3RhYmxlW10gPSB7CiAJCS5leHRyYTEJCT0gJnplcm8sCiAJfSwKICNlbmRpZgotI2lm
ZGVmIENPTkZJR19ISUdITUVNCiAJewogCQkucHJvY25hbWUJPSAiaGlnaG1lbV9pc19kaXJ0eWFi
bGUiLAogCQkuZGF0YQkJPSAmdm1faGlnaG1lbV9pc19kaXJ0eWFibGUsCkBAIC0xNDE2LDcgKzE0
MTUsNiBAQCBzdGF0aWMgc3RydWN0IGN0bF90YWJsZSB2bV90YWJsZVtdID0gewogCQkuZXh0cmEx
CQk9ICZ6ZXJvLAogCQkuZXh0cmEyCQk9ICZvbmUsCiAJfSwKLSNlbmRpZgogCXsKIAkJLnByb2Nu
YW1lCT0gInNjYW5fdW5ldmljdGFibGVfcGFnZXMiLAogCQkuZGF0YQkJPSAmc2Nhbl91bmV2aWN0
YWJsZV9wYWdlcywKZGlmZiAtLWdpdCBhL21tL3BhZ2Utd3JpdGViYWNrLmMgYi9tbS9wYWdlLXdy
aXRlYmFjay5jCmluZGV4IDYzODA3NTgzZDhlOC4uYjNiY2UxY2Q1OWQ1IDEwMDY0NAotLS0gYS9t
bS9wYWdlLXdyaXRlYmFjay5jCisrKyBiL21tL3BhZ2Utd3JpdGViYWNrLmMKQEAgLTI0MSw4ICsy
NDEsMTMgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcgZ2xvYmFsX2RpcnR5YWJsZV9tZW1vcnkodm9p
ZCkKIAl4ID0gZ2xvYmFsX3BhZ2Vfc3RhdGUoTlJfRlJFRV9QQUdFUykgKyBnbG9iYWxfcmVjbGFp
bWFibGVfcGFnZXMoKTsKIAl4IC09IG1pbih4LCBkaXJ0eV9iYWxhbmNlX3Jlc2VydmUpOwogCi0J
aWYgKCF2bV9oaWdobWVtX2lzX2RpcnR5YWJsZSkKKwlpZiAoIXZtX2hpZ2htZW1faXNfZGlydHlh
YmxlKSB7CisJCWNvbnN0IHVuc2lnbmVkIGxvbmcgR0JfcGFnZXMgPSAxMDI0KjEwMjQqMTAyNCAv
IFBBR0VfU0laRTsKKwogCQl4IC09IGhpZ2htZW1fZGlydHlhYmxlX21lbW9yeSh4KTsKKwkJaWYg
KHggPiBHQl9wYWdlcykKKwkJCXggPSBHQl9wYWdlczsKKwl9CiAKIAlyZXR1cm4geCArIDE7CS8q
IEVuc3VyZSB0aGF0IHdlIG5ldmVyIHJldHVybiAwICovCiB9Cg==
--089e0122f0f22fad9404e9e7f948--
