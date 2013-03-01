Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab3CAPva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:51:30 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:39483 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3CAPv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:51:29 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <201302152005.51575.arnd@arndb.de>
References: <20130215162657.6dd03d27e8cfed0c134b5dd3@canb.auug.org.au>
	<20130215173429.GA27707@kroah.com>
	<201302152005.51575.arnd@arndb.de>
Date: Fri, 1 Mar 2013 16:51:24 +0100
Message-ID: <CA+icZUUCRb9DafSj0Vhtq68mNxBPHVpSkeau+UEkfVb3Jv0k6g@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the char-misc tree
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Stevenson <david@avoncliff.com>
Content-Type: multipart/mixed; boundary=20cf30050e8ac1db3704d6defa35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf30050e8ac1db3704d6defa35
Content-Type: text/plain; charset=UTF-8

On Fri, Feb 15, 2013 at 9:05 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 15 February 2013, Greg KH wrote:
>> On Fri, Feb 15, 2013 at 04:26:57PM +1100, Stephen Rothwell wrote:
>> >
>> > After merging the char-misc tree, today's linux-next build (x86_64
>> > allmodconfig) produced this warning:
>> >
>> > drivers/w1/slaves/w1_therm.c: In function 'w1_therm_read':
>> > drivers/w1/slaves/w1_therm.c:245:15: warning: 'crc' may be used uninitialized in this function [-Wuninitialized]
>> >
>> > Its a false positive, but it was introduced by commit 867ff9880d5d
>> > ("w1_therm: Retries: remove old code add CRC")
>>
>> I don't see that here with gcc 4.7.1, perhaps you need to upgrade your
>> version of gcc to not show these false positives?
>
> I have finally put the pieces of the puzzle together. I already knew
> that some of these warnings only happen when building with -Os (even
> in gcc-4.8), since gcc turns off the inlining at a point after it
> determines that the variable might be used uninitialized but before
> determining that it's actually isn't.
>
> I think the best way forward is to disable this particular warning
> when building with -Os (which is enabled in allyesconfig). A false
> positive seems more harmful than a false negative here, because it
> prompts people to add broken initializations. This patch indeed
> makes the majority of the allyesconfig warnings on ARM go away.
> For the regular defconfig builds, we are already mostly clean,
> and those are built with -O2.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> diff --git a/Makefile b/Makefile
> index 0b4bf62..4d60d97 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -570,7 +570,7 @@ endif # $(dot-config)
>  all: vmlinux
>
>  ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
> -KBUILD_CFLAGS  += -Os
> +KBUILD_CFLAGS  += -Os $(call cc-option,-Wno-maybe-uninitialized,)
>  else
>  KBUILD_CFLAGS  += -O2
>  endif

I have seen a lot of such failures when using the Freetz (a small
router project) build-system with gcc-4.7-x where "-Os" is default
optimization-level.

Last, when I tried to integrate ltrace GIT snapshots into Freetz.
All these "build-errors" could be solved in changing ltrace code.
So, I would not talk about "false positives".

Furthermore, "-Wno-maybe-uninitialized" gcc-option is available
gcc-4-7+, so your patch is incomplete.
Setting it is a "workaround" and a bit rough to stop compilation.
Here, I have it only activated for ltrace compilation.

I am attaching my ltrace.mk file for Freetz.

Greetings from Tuebingen to Tuebingen,
- Sedat -

[ ltrace.mk ]
...
# Set compiler options to suppress warnings treated as errors
# Reference: gcc manual chapter "3.8 Options to Request or Suppress Warnings"
# <http://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#Warning-Options>
# EXAMPLE: TARGET_CC_OPTS := -Wno-error=maybe-uninitialized (here: gcc-4.7)
ifneq (,$(strip $(filter 4.7,$(TARGET_TOOLCHAIN_GCC_MAJOR_VERSION))))
TARGET_CC_OPTS := -Wno-error=maybe-uninitialized
else
TARGET_CC_OPTS :=
endif
...
- EOT -

--20cf30050e8ac1db3704d6defa35
Content-Type: application/octet-stream; name="ltrace.mk"
Content-Disposition: attachment; filename="ltrace.mk"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdrinulj0

JChjYWxsIFBLR19JTklUX0JJTiwgMC43LjkwLWdpdCkKJChQS0cpX1NPVVJDRTo9bHRyYWNlLSQo
JChQS0cpX1ZFUlNJT04pLnRhci5negojIENvbW1lbnQgTUQ1IGFzIGl0IGRpZmZlcnMgZm9yIGVh
Y2ggZG93bmxvYWRlZCB0YXJiYWxsIGZyb20gdXBzdHJlYW0gR2l0IHJlcG9zaXRvcnkKIyQoUEtH
KV9TT1VSQ0VfTUQ1Oj14eHgKIyBYWFg6IFdvcmthcm91bmQ6IEdlbmVyYXRlIGEgdGFyYmFsbCBm
cm9tIHVwc3RyZWFtIEdpdCByZXBvc2l0b3J5ICh1c2UgNyBkaWdpdHMpCiQoUEtHKV9HSVRfVkVS
U0lPTjo9YmMwZGU0MwokKFBLRylfU0lURTo9aHR0cDovL2Fub25zY20uZGViaWFuLm9yZy9naXR3
ZWIvP3A9Y29sbGFiLW1haW50L2x0cmFjZS5naXQ7YT1zbmFwc2hvdDtoPSQoJChQS0cpX0dJVF9W
RVJTSU9OKTtzZj10Z3oKCiQoUEtHKV9CSU5BUlk6PSQoJChQS0cpX0RJUikvbHRyYWNlCiQoUEtH
KV9DT05GOj0kKCQoUEtHKV9ESVIpL2V0Yy9sdHJhY2UuY29uZgokKFBLRylfVEFSR0VUX0JJTkFS
WTo9JCgkKFBLRylfREVTVF9ESVIpL3Vzci9zYmluL2x0cmFjZQokKFBLRylfVEFSR0VUX0NPTkY6
PSQoJChQS0cpX0RFU1RfRElSKS9ldGMvbHRyYWNlLmNvbmYKCiQoUEtHKV9ERVBFTkRTX09OIDo9
IGxpYmVsZgoKJChQS0cpX1JFQlVJTERfU1VCT1BUUyArPSBGUkVFVFpfUEFDS0FHRV9MVFJBQ0Vf
U1RBVElDCgojIENvcHkgb3JpZ2luYWwgaGVhZGVyIGZpbGVzIGFuZCByZWdlbmVyYXRlIHRoZW0g
dXNpbmcgbWtzeXNjYWxsZW50X21pcHMgYW5kIG1rc2lnbmFsZW50IHNjcmlwdHMKJChQS0cpX0NP
TkZJR1VSRV9QUkVfQ01EUyArPSAoIFwKCWNkIHN5c2RlcHMvbGludXgtZ251L21pcHMgOyBcCglj
cCBzeXNjYWxsZW50Lmggc3lzY2FsbGVudC5oLm9yaWcgOyBcCgljcCBzaWduYWxlbnQuaCBzaWdu
YWxlbnQuaC5vcmlnIDsgXAoJLi4vbWtzeXNjYWxsZW50X21pcHMgJChUQVJHRVRfVE9PTENIQUlO
X1NUQUdJTkdfRElSKS91c3IvaW5jbHVkZS9hc20vdW5pc3RkLmggPiBzeXNjYWxsZW50LmggOyBc
CgkuLi9ta3NpZ25hbGVudCAkKFRBUkdFVF9UT09MQ0hBSU5fU1RBR0lOR19ESVIpL3Vzci9pbmNs
dWRlL2FzbS9zaWduYWwuaCA+IHNpZ25hbGVudC5oIDsgXAoJKTsKCiMgVXNlIGF1dG9nZW4uc2gg
c2NyaXB0IHRvIGdlbmVyYXRlIG1pc3NpbmcgZmlsZXMgbGlrZSBjb25maWd1cmUgZXRjLgokKFBL
RylfQ09ORklHVVJFX1BSRV9DTURTICs9IC4vYXV0b2dlbi5zaCA7CgojIERpc2FibGUgZGVtYW5n
bGluZyBzdXBwb3J0CiQoUEtHKV9DT05GSUdVUkVfRU5WICs9IGFjX2N2X2xpYl9pYmVydHlfY3Bs
dXNfZGVtYW5nbGU9bm8KJChQS0cpX0NPTkZJR1VSRV9FTlYgKz0gYWNfY3ZfbGliX3N0ZGNwcF9f
X2N4YV9kZW1hbmdsZT1ubwokKFBLRylfQ09ORklHVVJFX0VOViArPSBhY19jdl9saWJfc3VwY3Bw
X19fY3hhX2RlbWFuZ2xlPW5vCgokKFBLRylfQ09ORklHVVJFX0VOViArPSBMRD0iJChUQVJHRVRf
TEQpIgoKIyBTZXQgY29tcGlsZXIgb3B0aW9ucyB0byBzdXBwcmVzcyB3YXJuaW5ncyB0cmVhdGVk
IGFzIGVycm9ycwojIFJlZmVyZW5jZTogZ2NjIG1hbnVhbCBjaGFwdGVyICIzLjggT3B0aW9ucyB0
byBSZXF1ZXN0IG9yIFN1cHByZXNzIFdhcm5pbmdzIgojIDxodHRwOi8vZ2NjLmdudS5vcmcvb25s
aW5lZG9jcy9nY2MvV2FybmluZy1PcHRpb25zLmh0bWwjV2FybmluZy1PcHRpb25zPgojIEVYQU1Q
TEU6IFRBUkdFVF9DQ19PUFRTIDo9IC1Xbm8tZXJyb3I9bWF5YmUtdW5pbml0aWFsaXplZCAoaGVy
ZTogZ2NjLTQuNykKaWZuZXEgKCwkKHN0cmlwICQoZmlsdGVyIDQuNywkKFRBUkdFVF9UT09MQ0hB
SU5fR0NDX01BSk9SX1ZFUlNJT04pKSkpClRBUkdFVF9DQ19PUFRTIDo9IC1Xbm8tZXJyb3I9bWF5
YmUtdW5pbml0aWFsaXplZAplbHNlClRBUkdFVF9DQ19PUFRTIDo9CmVuZGlmCgojIFhYWDogV29y
a2Fyb3VuZDogRG93bmxvYWQgR2l0IHRhcmJhbGwgKHJlcGxhY2VzICQoUEtHX1NPVVJDRV9ET1dO
TE9BRCkpCiQoRExfRElSKS8kKExUUkFDRV9TT1VSQ0UpOiB8ICQoRExfRElSKQoJd2dldCAtTyAk
KERMX0RJUikvJChMVFJBQ0VfU09VUkNFKSAiJChMVFJBQ0VfU0lURSkiCgokKHBrZyktZG93bmxv
YWQ6ICQoRExfRElSKS8kKExUUkFDRV9TT1VSQ0UpCgojIFhYWDogV29ya2Fyb3VuZDogVW5wYWNr
IEdpdCB0YXJiYWxsIGFuZCBhcHBseSBwYXRjaGVzIChyZXBsYWNlcyAkKFBLR19VTlBBQ0tFRCkp
CiQoJChQS0cpX0RJUikvLnVucGFja2VkOiAkKERMX0RJUikvJChMVFJBQ0VfU09VUkNFKSB8ICQo
U09VUkNFX0RJUikKCW1rZGlyIC1wICQoTFRSQUNFX0RJUikKCXRhciAtQyAkKExUUkFDRV9ESVIp
ICQoVkVSQk9TRSkgLS1zdHJpcC1jb21wb25lbnRzPTEgXAoJCS14ZiAkKERMX0RJUikvJChMVFJB
Q0VfU09VUkNFKQoJZm9yIGkgaW4gJChMVFJBQ0VfTUFLRV9ESVIpL3BhdGNoZXMvKi5wYXRjaDsg
ZG8gXAoJCSQoUEFUQ0hfVE9PTCkgJChMVFJBQ0VfRElSKSAkJGk7IFwKCWRvbmU7Cgl0b3VjaCAk
QAoKJChwa2cpLXVucGFja2VkOiAkKCQoUEtHKV9ESVIpLy51bnBhY2tlZAoKIyBYWFg6IFdvcmth
cm91bmQ6IENvbW1lbnRlZCBkdWUgdG8gc3dpdGNoIHRvIEdpdCB0YXJiYWxsIHVzYWdlCiMkKFBL
R19TT1VSQ0VfRE9XTkxPQUQpCiMkKFBLR19VTlBBQ0tFRCkKJChQS0dfQ09ORklHVVJFRF9DT05G
SUdVUkUpCgokKCQoUEtHKV9DT05GKTogJCgkKFBLRylfRElSKS8udW5wYWNrZWQKCiQoJChQS0cp
X1RBUkdFVF9DT05GKTogJCgkKFBLRylfQ09ORikKCW1rZGlyIC1wICQoZGlyICRAKQoJY3AgJDwg
JEAKCiQoJChQS0cpX0JJTkFSWSk6ICQoJChQS0cpX0RJUikvLmNvbmZpZ3VyZWQKCSQoU1VCTUFL
RSkgLUMgJChMVFJBQ0VfRElSKSBcCgkJQVJDSD0iJChLRVJORUxfQVJDSCkiIFwKCQlDRkxBR1M9
IiQoVEFSR0VUX0NGTEFHUykgJChUQVJHRVRfQ0NfT1BUUykiIFwKCQkkKGlmICQoRlJFRVRaX1BB
Q0tBR0VfTFRSQUNFX1NUQVRJQyksTERGTEFHUz0iLWFsbC1zdGF0aWMiKQoKJCgkKFBLRylfVEFS
R0VUX0JJTkFSWSk6ICQoJChQS0cpX0JJTkFSWSkKCSQoSU5TVEFMTF9CSU5BUllfU1RSSVApCgok
KHBrZyk6CgokKHBrZyktcHJlY29tcGlsZWQ6ICQoJChQS0cpX1RBUkdFVF9CSU5BUlkpICQoJChQ
S0cpX1RBUkdFVF9DT05GKQoKJChwa2cpLWNsZWFuOgoJLSQoU1VCTUFLRSkgLUMgJChMVFJBQ0Vf
RElSKSBjbGVhbgoKJChwa2cpLXVuaW5zdGFsbDoKCSQoUk0pICQoTFRSQUNFX1RBUkdFVF9CSU5B
UlkpCgkkKFJNKSAkKExUUkFDRV9UQVJHRVRfQ09ORikKCi5QSE9OWTogJChwa2cpLWRvd25sb2Fk
ICQocGtnKS11bnBhY2tlZCAkKHBrZykgJChwa2cpLXByZWNvbXBpbGVkICQocGtnKS1jbGVhbiAk
KHBrZyktdW5pbnN0YWxsCgokKFBLR19GSU5JU0gpCg==
--20cf30050e8ac1db3704d6defa35--
