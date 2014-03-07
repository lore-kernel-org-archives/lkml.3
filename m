Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaCGVPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:15:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39750 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbaCGVPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:15:48 -0500
Message-ID: <531A36F7.6020101@zytor.com>
Date: Fri, 07 Mar 2014 13:15:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, vgoyal@redhat.com,
        ebiederm@xmission.com
Subject: Re: [PATCH] x86: Skip latched NMIs on early boot in kdump
References: <1394221143-29713-1-git-send-email-dzickus@redhat.com>
In-Reply-To: <1394221143-29713-1-git-send-email-dzickus@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/mixed;
 boundary="------------020609010704020905080605"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020609010704020905080605
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/07/2014 11:39 AM, Don Zickus wrote:
> A customer generated an external NMI using their iLO to test kdump worked.
> Unfortunately, the machine hung.  Disabling the nmi_watchdog made things work.
> 
> I speculated the external NMI fired, caused the machine to panic (as expected)
> and the perf NMI from the watchdog came in and was latched.  My guess was this
> somehow caused the hang.
> 

... as any other unexpected exception would.

> 
> I also do not fully understand why the latched NMI is not happening immediately
> after the load idt call or why it comes after a page fault (the
> early_make_pgtable).  Further adding to my confusion is why the early printk
> magic didn't dump a stack as I believe I had that setup on my commandline.
> But I figured I would just report what I have observed.
> 

If the kdump is initiated from NMI context, I'm wondering if it might be
possible that we haven't actually executed an IRET until this one
happens, and the IRET re-enables NMI.

> My testing and debugging were based off a 3.10 kernel (RHEL-7) but has included
> Seiji's tracepoint cleanups to arch/x86/kernel/head_64.S|head64.c.  Not much
> has changed upstream here.  Also 3.14-rc4 still has the same hang.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>

We really shouldn't be doing the fixup lookup for NMI, either.  Probably
it makes more sense to just IRET on NMI until we have the real interrupt
vectors set up, but it needs to be done a little earlier.

How does this patch work for you?

	-hpa


--------------020609010704020905080605
Content-Type: text/plain; charset=UTF-8;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="diff"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9oZWFkXzMyLlMgYi9hcmNoL3g4Ni9rZXJu
ZWwvaGVhZF8zMi5TCmluZGV4IDgxYmEyNzYuLmQyYTIxNTkgMTAwNjQ0Ci0tLSBhL2FyY2gv
eDg2L2tlcm5lbC9oZWFkXzMyLlMKKysrIGIvYXJjaC94ODYva2VybmVsL2hlYWRfMzIuUwpA
QCAtNTQ0LDYgKzU0NCwxMCBAQCBFTkRQUk9DKGVhcmx5X2lkdF9oYW5kbGVycykKIAkvKiBU
aGlzIGlzIGdsb2JhbCB0byBrZWVwIGdhcyBmcm9tIHJlbGF4aW5nIHRoZSBqdW1wcyAqLwog
RU5UUlkoZWFybHlfaWR0X2hhbmRsZXIpCiAJY2xkCisKKwljbXBsICRYODZfVFJBUF9OTUks
KCVlc3ApCisJamUgaXNfbm1pCQkjIElnbm9yZSBOTUkKKwogCWNtcGwgJDIsJXNzOmVhcmx5
X3JlY3Vyc2lvbl9mbGFnCiAJamUgaGx0X2xvb3AKIAlpbmNsICVzczplYXJseV9yZWN1cnNp
b25fZmxhZwpAQCAtNTk0LDggKzU5OCw5IEBAIGV4X2VudHJ5OgogCXBvcCAlZWR4CiAJcG9w
ICVlY3gKIAlwb3AgJWVheAotCWFkZGwgJDgsJWVzcAkJLyogZHJvcCB2ZWN0b3IgbnVtYmVy
IGFuZCBlcnJvciBjb2RlICovCiAJZGVjbCAlc3M6ZWFybHlfcmVjdXJzaW9uX2ZsYWcKK2lz
X25taToKKwlhZGRsICQ4LCVlc3AJCS8qIGRyb3AgdmVjdG9yIG51bWJlciBhbmQgZXJyb3Ig
Y29kZSAqLwogCWlyZXQKIEVORFBST0MoZWFybHlfaWR0X2hhbmRsZXIpCiAKZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2tlcm5lbC9oZWFkXzY0LlMgYi9hcmNoL3g4Ni9rZXJuZWwvaGVhZF82
NC5TCmluZGV4IGUxYWFiZGIuLjMzZjM2YzcgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5l
bC9oZWFkXzY0LlMKKysrIGIvYXJjaC94ODYva2VybmVsL2hlYWRfNjQuUwpAQCAtMzQzLDYg
KzM0Myw5IEBAIGVhcmx5X2lkdF9oYW5kbGVyczoKIEVOVFJZKGVhcmx5X2lkdF9oYW5kbGVy
KQogCWNsZAogCisJY21wbCAkWDg2X1RSQVBfTk1JLCglcnNwKQorCWplIGlzX25taQkJIyBJ
Z25vcmUgTk1JCisKIAljbXBsICQyLGVhcmx5X3JlY3Vyc2lvbl9mbGFnKCVyaXApCiAJanog
IDFmCiAJaW5jbCBlYXJseV9yZWN1cnNpb25fZmxhZyglcmlwKQpAQCAtNDA1LDggKzQwOCw5
IEBAIEVOVFJZKGVhcmx5X2lkdF9oYW5kbGVyKQogCXBvcHEgJXJkeAogCXBvcHEgJXJjeAog
CXBvcHEgJXJheAotCWFkZHEgJDE2LCVyc3AJCSMgZHJvcCB2ZWN0b3IgbnVtYmVyIGFuZCBl
cnJvciBjb2RlCiAJZGVjbCBlYXJseV9yZWN1cnNpb25fZmxhZyglcmlwKQoraXNfbm1pOgor
CWFkZHEgJDE2LCVyc3AJCSMgZHJvcCB2ZWN0b3IgbnVtYmVyIGFuZCBlcnJvciBjb2RlCiAJ
SU5URVJSVVBUX1JFVFVSTgogRU5EUFJPQyhlYXJseV9pZHRfaGFuZGxlcikKIAo=
--------------020609010704020905080605--
