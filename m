Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab3IZHlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:41:50 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:37393 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab3IZHls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:41:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130918143346.GB3891@infradead.org>
References: <20130917190606.GB3918@infradead.org> <52398FF1.5020502@redhat.com>
 <20130918143346.GB3891@infradead.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 26 Sep 2013 09:41:27 +0200
Message-ID: <CAK1hOcNbQm6-tYfnn+hLF=AWn1kwYqhtYJjs_6taM5s-ka529Q@mail.gmail.com>
Subject: Re: [RFC] Full syscall argument decode in "perf trace"
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7ba975cc957ff204e7448057
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7ba975cc957ff204e7448057
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Sep 18, 2013 at 4:33 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
>> > Look at the tmp.perf/trace2 branch in my git repo, tglx and Ingo added a
>> > tracepoint to vfs_getname to use that.
>>
>> I know that this is the way how to fetch syscall args without stopping,
>> yes.
>>
>> The problem: ~100 more tracepoints need to be added merely to get
>> to the point where strace already is, wrt quality of syscall decoding.
>> strace has nearly 300 separate custom syscall formatting functions,
>> some of them quite complex.
>>
>> If we need to add syscall stopping feature (which, as I said above,
>> will be necessary anyway IMO), then syscall decoding can be as good
>> as strace *already*. Then, gradually more tracepoints are added
>> to make it faster.
>>
>> I am thinking about going into this direction.
>>
>> Therefore my question should be restated as:
>>
>> Would perf developers accept the "syscall pausing" feature,
>> or it won't be accepted?
>
> Do you have some patch for us to try?

I have a patch which is a bit strace specific: it sidesteps
the question of the synchronization between traced process
and its tracer by using ptrace's existing method of reporting stops.

This works for strace, and is very easy to implement.
Naturally, other tracers (e.g. "perf trace" wouldn't
want to start using ptrace! Synchronization needs
to be done in some other way, not as a ptrace stop.

For one, the stopping flag needs to be a counter, so that
more than one tracer can use this feature concurrently.

But anyway, I am attaching it.

It adds a new flag, attr.sysexit_stop, which makes process stop
at next syscall exit when this tracepoint overflows.

-- 
vda

--047d7ba975cc957ff204e7448057
Content-Type: application/octet-stream; name="perf_trace_stop_RFC.diff"
Content-Disposition: attachment; filename="perf_trace_stop_RFC.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hm1oa4u10

ZGlmZiAtdXJwIGxpbnV4LTMuMTAuMTEtMTAwLmZjMTgueDg2XzY0Lk9SRy9pbmNsdWRlL3VhcGkv
bGludXgvcGVyZl9ldmVudC5oIGxpbnV4LTMuMTAuMTEtMTAwLmZjMTgueDg2XzY0LmNsZWFuMi9p
bmNsdWRlL3VhcGkvbGludXgvcGVyZl9ldmVudC5oCi0tLSBsaW51eC0zLjEwLjExLTEwMC5mYzE4
Lng4Nl82NC5PUkcvaW5jbHVkZS91YXBpL2xpbnV4L3BlcmZfZXZlbnQuaAkyMDEzLTA3LTAxIDAw
OjEzOjI5LjAwMDAwMDAwMCArMDIwMAorKysgbGludXgtMy4xMC4xMS0xMDAuZmMxOC54ODZfNjQu
Y2xlYW4yL2luY2x1ZGUvdWFwaS9saW51eC9wZXJmX2V2ZW50LmgJMjAxMy0wOS0yNSAyMzo0MToz
MS4yNjU1NzY4OTcgKzAyMDAKQEAgLTI3Myw3ICsyNzMsOSBAQCBzdHJ1Y3QgcGVyZl9ldmVudF9h
dHRyIHsKIAkJCQlleGNsdWRlX2NhbGxjaGFpbl9rZXJuZWwgOiAxLCAvKiBleGNsdWRlIGtlcm5l
bCBjYWxsY2hhaW5zICovCiAJCQkJZXhjbHVkZV9jYWxsY2hhaW5fdXNlciAgIDogMSwgLyogZXhj
bHVkZSB1c2VyIGNhbGxjaGFpbnMgKi8KIAotCQkJCV9fcmVzZXJ2ZWRfMSAgIDogNDE7CisJCQkJ
c3lzZXhpdF9zdG9wICAgOiAxLAorCisJCQkJX19yZXNlcnZlZF8xICAgOiA0MDsKIAogCXVuaW9u
IHsKIAkJX191MzIJCXdha2V1cF9ldmVudHM7CSAgLyogd2FrZXVwIGV2ZXJ5IG4gZXZlbnRzICov
CmRpZmYgLXVycCBsaW51eC0zLjEwLjExLTEwMC5mYzE4Lng4Nl82NC5PUkcva2VybmVsL2V2ZW50
cy9jb3JlLmMgbGludXgtMy4xMC4xMS0xMDAuZmMxOC54ODZfNjQuY2xlYW4yL2tlcm5lbC9ldmVu
dHMvY29yZS5jCi0tLSBsaW51eC0zLjEwLjExLTEwMC5mYzE4Lng4Nl82NC5PUkcva2VybmVsL2V2
ZW50cy9jb3JlLmMJMjAxMy0wOS0yMyAxMjowMzoyNS43MTkyNTM5MDggKzAyMDAKKysrIGxpbnV4
LTMuMTAuMTEtMTAwLmZjMTgueDg2XzY0LmNsZWFuMi9rZXJuZWwvZXZlbnRzL2NvcmUuYwkyMDEz
LTA5LTI1IDIzOjQzOjAwLjM3NjYyMTU4NCArMDIwMApAQCAtNTAyNiw2ICs1MDI2LDEwIEBAIHN0
YXRpYyBpbnQgX19wZXJmX2V2ZW50X292ZXJmbG93KHN0cnVjdAogCQlpcnFfd29ya19xdWV1ZSgm
ZXZlbnQtPnBlbmRpbmcpOwogCX0KIAorCWlmICghaW5faW50ZXJydXB0KCkgJiYgZXZlbnQtPmF0
dHIuc3lzZXhpdF9zdG9wICYmIGN1cnJlbnQtPnB0cmFjZSkgeworCQlzZXRfdHNrX3RocmVhZF9m
bGFnKGN1cnJlbnQsIFRJRl9TWVNDQUxMX1RSQUNFKTsKKwl9CisKIAlyZXR1cm4gcmV0OwogfQog
Cg==
--047d7ba975cc957ff204e7448057--
