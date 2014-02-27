Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaB0Wxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 17:53:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33234 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbaB0Wxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 17:53:47 -0500
Message-ID: <530FC1C6.5040209@zytor.com>
Date: Thu, 27 Feb 2014 14:52:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Vince Weaver <vincent.weaver@maine.edu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu>	<20140224172536.GD9987@twins.programming.kicks-ass.net>	<alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu>	<530B841F.5050803@zytor.com>	<alpine.DEB.2.10.1402241258590.20170@vincent-weaver-1.um.maine.edu>	<alpine.DEB.2.10.1402241302210.20560@vincent-weaver-1.um.maine.edu>	<530B90A5.3090302@zytor.com>	<20140224141329.1cd3bb52@gandalf.local.home>	<20140224193043.GP6835@laptop.programming.kicks-ass.net>	<530C12CA.6070308@zytor.com>	<alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu>	<dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com>	<20140225094352.73e0e28c@gandalf.local.home>	<alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu>	<alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>	<alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu> <20140227173150.4e5ed747@gandalf.local.home>
In-Reply-To: <20140227173150.4e5ed747@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: multipart/mixed;
 boundary="------------080805030704060009040308"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080805030704060009040308
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/27/2014 02:31 PM, Steven Rostedt wrote:
> 
> Yeah, something is getting mesed up.
> 

What it *looks* like to me is that we try to nest the cr2 save/restore,
which doesn't nest because it is a percpu variable.

... except in the x86-64 case, we *ALSO* save/restore cr2 inside
entry_64.S, which makes the stuff in do_nmi completely redundant and
there for no good reason.

I would actually suggest we do the equivalent on i386 as well.

Vince, could you try this patch as an experiment?



--------------080805030704060009040308
Content-Type: text/plain; charset=UTF-8;
 name="patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="patch"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2xpYi91c2VyY29weS5jIGIvYXJjaC94ODYvbGliL3Vz
ZXJjb3B5LmMKaW5kZXggZGRmOWVjYi4uOTM4ZTQ1YyAxMDA2NDQKLS0tIGEvYXJjaC94ODYv
bGliL3VzZXJjb3B5LmMKKysrIGIvYXJjaC94ODYvbGliL3VzZXJjb3B5LmMKQEAgLTEwLDYg
KzEwLDggQEAKICNpbmNsdWRlIDxhc20vd29yZC1hdC1hLXRpbWUuaD4KICNpbmNsdWRlIDxs
aW51eC9zY2hlZC5oPgogCisjaW5jbHVkZSA8YXNtL3Byb2Nlc3Nvci5oPgorCiAvKgogICog
V2UgcmVseSBvbiB0aGUgbmVzdGVkIE5NSSB3b3JrIHRvIGFsbG93IGF0b21pYyBmYXVsdHMg
ZnJvbSB0aGUgTk1JIHBhdGg7IHRoZQogICogbmVzdGVkIE5NSSBwYXRocyBhcmUgY2FyZWZ1
bCB0byBwcmVzZXJ2ZSBDUjIuCkBAIC0xOCw2ICsyMCw3IEBAIHVuc2lnbmVkIGxvbmcKIGNv
cHlfZnJvbV91c2VyX25taSh2b2lkICp0bywgY29uc3Qgdm9pZCBfX3VzZXIgKmZyb20sIHVu
c2lnbmVkIGxvbmcgbikKIHsKIAl1bnNpZ25lZCBsb25nIHJldDsKKwl1bnNpZ25lZCBsb25n
IGNyMjsKIAogCWlmIChfX3JhbmdlX25vdF9vayhmcm9tLCBuLCBUQVNLX1NJWkUpKQogCQly
ZXR1cm4gMDsKQEAgLTI3LDkgKzMwLDExIEBAIGNvcHlfZnJvbV91c2VyX25taSh2b2lkICp0
bywgY29uc3Qgdm9pZCBfX3VzZXIgKmZyb20sIHVuc2lnbmVkIGxvbmcgbikKIAkgKiBkaXNh
YmxlIHBhZ2VmYXVsdHMgc28gdGhhdCBpdHMgYmVoYXZpb3VyIGlzIGNvbnNpc3RlbnQgZXZl
biB3aGVuCiAJICogY2FsbGVkIGZvcm0gb3RoZXIgY29udGV4dHMuCiAJICovCisJY3IyID0g
cmVhZF9jcjIoKTsKIAlwYWdlZmF1bHRfZGlzYWJsZSgpOwogCXJldCA9IF9fY29weV9mcm9t
X3VzZXJfaW5hdG9taWModG8sIGZyb20sIG4pOwogCXBhZ2VmYXVsdF9lbmFibGUoKTsKKwl3
cml0ZV9jcjIoY3IyKTsKIAogCXJldHVybiByZXQ7CiB9Cg==
--------------080805030704060009040308--
