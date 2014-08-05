Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaHEDTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 23:19:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:52755 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754352AbaHEDTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 23:19:22 -0400
Date: Mon, 4 Aug 2014 23:19:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
        Michel =?ISO-8859-1?B?RORuemVy?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140804231918.36bd06f4@gandalf.local.home>
In-Reply-To: <CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
References: <20140723182518.GD3935@laptop>
	<CA+55aFyFT9n5wUNifEHY6+t2bEcD91kL7+dqXuBMSMJvLeDDJQ@mail.gmail.com>
	<20140723184111.GG3935@laptop>
	<CA+55aFwQfwfAP6U77_nD_mSvoygj=cZ09N644hKRtzgLnEqhZQ@mail.gmail.com>
	<20140723190230.GH3935@laptop>
	<CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>
	<53D064C7.5050807@daenzer.net>
	<CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
	<53D1B1EF.7030603@daenzer.net>
	<20140725035527.GA30108@pg-vmw-gw1>
	<20140725140237.GB32669@home.goodmis.org>
	<CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/EY6f5mVpsPZ2v5Fdq=b68VA"
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/EY6f5mVpsPZ2v5Fdq=b68VA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, 25 Jul 2014 11:29:06 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Jul 25, 2014 at 7:02 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > But wouldn't it be rather trivial to run a static analyzer on the final
> > vmlinux to make sure there are no red zones? I mean, you would only need
> > to read each function and check to make sure that the offset of rbp is
> > within the change of rsp, wouldn't you?
> >
> > Almost seems like an objdump -rd into a perl script could do this.
> 
> I'm sure it's possible, but it sounds potentially complicated. It's
> not like the function prologue is fixed, and gcc will create code
> (including conditional branches etc) before the whole frame setup if
> there are simple things that can be done purely with the
> callee-clobbered registers etc.
> 
> Some simple pattern to make sure that the "sub $frame-size,%rsp" comes
> before any accesses to (%rbp) (when frame pointers are enabled)
> *might* work, but it might also end up missing things.
> 
> You want to try?
> 

I tried :-)

Seems to stay clean with my x86_64 vmlinux build. I compiled the fair.s
file and tested it and it got this:

$ objump -dr fair.o | ./check-vmlinux.pl
ERROR: <load_balance>: depth=-40 offset=136 at 4210
    3572:	48 c7 85 78 ff ff ff 	movq   $0x0,-0x88(%rbp)
ERROR: <sched_group_set_shares>: depth=8 offset=48 at 5734
    4a79:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
ERROR: <sched_group_set_shares>: depth=8 offset=48 at 5743
    4a9c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi

The sched_group_set_shares errors seem to be bogus as that is done
after %rbp has been popped. Looks to be code that was jumped to from
the main body. I could probably fix this by ignoring code after a pop
of %rbp. Or make it more complex and be a bit smarter about branches.

The script will read a file if passed by parameter, otherwise it reads
standard input.

e.g.

$ objump -dr fair.o | ./check-vmlinux.pl

or

$ objdump -dr fair.o > /tmp/fair.dump
$ ./check-vmlinux.pl /tmp/fair.dump

produce the same.

It's a little hacky, but I only spent a half hour at most on it.

-- Steve

--MP_/EY6f5mVpsPZ2v5Fdq=b68VA
Content-Type: application/x-perl
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=check-vmlinux.pl

IyEvdXNyL2Jpbi9wZXJsIC13CiMgQ29weXJpZ2h0IFN0ZXZlbiBSb3N0ZWR0LCBSZWQgSGF0IElu
Yy4KIwojIExpY2Vuc2VkIHVuZGVyIEdQTCB2MgoKbXkgJHN0YXJ0X3N0YXRlID0gMDsKbXkgJGZ1
bmN0aW9uX3N0YXRlID0gMTsKbXkgJGZyYW1lX3N0YXRlID0gMjsKCm15ICRzdGF0ZSA9IC0xOwpt
eSAkZGVwdGggPSAwOwpteSAkZnVuYzsKCmlmICgkI0FSR1YgPj0gMCkgewogICAgb3BlbiBJTiwg
JEFSR1ZbMF0gb3IgZGllICJDYW4ndCBvcGVuICRBUkdWWzBdXG4iOwogICAgY2xvc2UgU1RESU47
CiAgICAqU1RESU4gPSAqSU47Cn0KCm15ICRlcnIgPSAwOwoKc3ViIHByb2Nlc3NfbnVtIHsKICAg
IG15ICgkbnVtKSA9IEBfOwoKICAgIG15ICR2YWw7CgogICAgIyBjaGVjayBpZiBpdCBpcyBuZWdh
dGl2ZQogICAgaWYgKCRudW0gPX4gcy9eMHhmZmZmZmZmZi8weC8pIHsKCSR2YWwgPSB1bnBhY2so
J2wnLCBwYWNrKCdMJywgb2N0KCRudW0pKSk7CiAgICB9IGVsc2UgewoJJHZhbCA9IG9jdCAkbnVt
OwogICAgfQoKICAgIHJldHVybiAkdmFsOwp9Cgp3aGlsZSAoPD4pIHsKICAgIGlmICgvXltbOnhk
aWdpdDpdXStccyg8XFMrPik6LykgewoJJHN0YXRlID0gJGZ1bmN0aW9uX3N0YXRlOwoJJGZ1bmMg
PSAkMTsKCW5leHQ7CiAgICB9CgogICAgaWYgKC9cc3JldHEvKSB7Cgkkc3RhdGUgPSAkc3RhcnRf
c3RhdGU7CgluZXh0OwogICAgfQoKICAgIGlmICgvXHNtb3ZccytcJXJzcCxcJXJicC8pIHsKCSRz
dGF0ZSA9ICRmcmFtZV9zdGF0ZTsKCSRkZXB0aCA9IDA7CgluZXh0OwogICAgfQoKICAgIG5leHQg
aWYgKCRzdGF0ZSAhPSAkZnJhbWVfc3RhdGUpOwoKICAgIGlmICgvXHNwdXNoXHMrXCUvIHx8IC9c
c3B1c2hmcVxzKiQvIHx8IC9cc3B1c2hxXHMqKC0pPzB4LykgewoJJGRlcHRoIC09IDg7CgluZXh0
OwogICAgfQoKICAgIGlmICgvXHNwb3BccytcJS8gfHwgL1xzcG9wZnFccyokLykgewoJJGRlcHRo
ICs9IDg7CgluZXh0OwogICAgfQoKICAgIGlmICgvXHNzdWJccytcJCgweFtbOnhkaWdpdDpdXSsp
LFwlcnNwLykgewoJJGRlcHRoIC09IHByb2Nlc3NfbnVtKCQxKTsKCW5leHQ7CiAgICB9CgogICAg
aWYgKC9cc2xlYVxzLykgewoJIyBpZ25vcmUgYWRkcmVzcyBjYWxjdWxhdGlvbnMKCW5leHQ7CiAg
ICB9CgogICAgaWYgKC9cc2FkZFxzK1wkKDB4W1s6eGRpZ2l0Ol1dKyksXCVyc3AvKSB7CgkkZGVw
dGggKz0gcHJvY2Vzc19udW0oJDEpOwoJbmV4dDsKICAgIH0KCiAgICBpZiAoLy0weChbWzp4ZGln
aXQ6XV0rKVwoXCVyYnBcKS8pIHsKCW15ICRvZmZzZXQgPSBoZXggJDE7CglpZiAoJG9mZnNldCAr
ICRkZXB0aCA+IDApIHsKCSAgICBwcmludCAiRVJST1I6ICRmdW5jOiBkZXB0aD0kZGVwdGggb2Zm
c2V0PSRvZmZzZXQgYXQgJC5cbiI7CgkgICAgcHJpbnQ7CgkgICAgJGVycisrOwoJfQogICAgfQp9
CgppZiAoISRlcnIpIHsKICAgIHByaW50ICJBbGwgY2xlYW4hXG4iOwp9Cg==

--MP_/EY6f5mVpsPZ2v5Fdq=b68VA--
