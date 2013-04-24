Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab3DXKOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:14:04 -0400
Received: from multi.imgtec.com ([194.200.65.239]:53282 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751Ab3DXKOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:14:02 -0400
Message-ID: <5177B061.50107@imgtec.com>
Date: Wed, 24 Apr 2013 11:13:53 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, <rusty@rustcorp.com.au>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, <arjan@infradead.org>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>
Subject: Re: [PATCH] x86_32: Fix module version table mismatch.
References: <CAHp75VdDwh0wgCWrVDcPps1C2qfdDZra15y9BQvzfWHzSMqbWA@mail.gmail.com> <CAHp75Vfh6Bpk4j3crVEAo3UtJEqpyucbQw+AzJvO85uRJ6gVgg@mail.gmail.com> <201304222326.IJB21395.FOtVJFHFQMOOSL@I-love.SAKURA.ne.jp> <201304232140.FGF73904.QJOFOVtHFFMSOL@I-love.SAKURA.ne.jp> <51772CD3.3040405@zytor.com> <51772EBC.1050600@zytor.com>
In-Reply-To: <51772EBC.1050600@zytor.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_04_24_11_13_55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/04/13 02:00, H. Peter Anvin wrote:
> On 04/23/2013 05:52 PM, H. Peter Anvin wrote:
>> On 04/23/2013 05:40 AM, Tetsuo Handa wrote:
>>> Commit a4b6a77b "module: fix symbol versioning with symbol prefixes" broke
>>> loading of net/ipv6/ipv6.ko built with CONFIG_MODVERSIONS=y for x86_32.
>>
>> This really does seem to be the offending commit, although I'm still
>> confused how the heck that is possible.
>>
> 
> OK, now I grok.
> 
> The bug is the use of VMLINUX_SYMBOL_STR(%s) which expands at the time
> the output of modpost is compiled.  However, VMLINUX_SYMBOL_STR() unlike
> __VMLINUX_SYMBOL_STR() does macro expansion on its argument, which is
> actively wrong here.

Yes, nasty bug there (sorry!)

> I think the choice is either to change this to __VMLINUX_SYMBOL_STR() or
> re-introduce CONFIG_SYMBOL_PREFIX (or its equivalent) so that modprobe
> can emit it at compile time

Using __VMLINUX_SYMBOL_STR looks like the correct solution to me.

> (assuming there even should *be* a prefix on
> the symbol here, i.e. that the compiler won't add it.)

[__]VMLINUX_SYMBOL_STR expands to a string (e.g. "_" "memcmp" or just
"memcmp") so the compiler won't touch it.

> 
> Either way -- James, Rusty, this is in your court.

How does the patch below look? I presume this is preferred over
making VMLINUX_SYMBOL_STR non-argument-expanding?

Thanks
James

Subject: [PATCH 1/1] modpost: fix unwanted VMLINUX_SYMBOL_STR expansion

Commit a4b6a77b77ba4f526392612c2365797fab956014 ("module: fix symbol
versioning with symbol prefixes") broke the MODVERSIONS loading of any
module using memcmp (e.g. ipv6) on x86_32, as it's defined to
__builtin_memcmp which is expanded by VMLINUX_SYMBOL_STR. Use
__VMLINUX_SYMBOL_STR instead which doesn't expand the argument.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 scripts/mod/modpost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 1f90961..a4be8e1 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1957,7 +1957,7 @@ static int add_versions(struct buffer *b, struct module *mod)
 				s->name, mod->name);
 			continue;
 		}
-		buf_printf(b, "\t{ %#8x, VMLINUX_SYMBOL_STR(%s) },\n",
+		buf_printf(b, "\t{ %#8x, __VMLINUX_SYMBOL_STR(%s) },\n",
 			   s->crc, s->name);
 	}
 
-- 
1.8.1.2

