Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaHSSLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:11:38 -0400
Received: from ozlabs.org ([103.22.144.67]:39113 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbaHSSLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:11:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>, Bertrand Jacquin <beber@meleeweb.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 2/3] kbuild: handle module compression while running 'make modules_install'.
In-Reply-To: <87lhqkmxdl.fsf@tassilo.jf.intel.com>
References: <1408215016-1848-1-git-send-email-beber@meleeweb.net> <1408215016-1848-3-git-send-email-beber@meleeweb.net> <87lhqkmxdl.fsf@tassilo.jf.intel.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 20 Aug 2014 03:25:45 +0930
Message-ID: <87iolojrdq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:
> Bertrand Jacquin <beber@meleeweb.net> writes:
>>  
>> +# CONFIG_MODULE_COMPRESS, if defined, will cause module to be compressed
>> +# after they are installed in agreement with CONFIG_MODULE_COMPRESS_GZIP
>> +# or CONFIG_MODULE_COMPRESS_XZ.
>> +
>> +mod_compress_cmd = true
>> +ifdef CONFIG_MODULE_COMPRESS
>> +  ifdef CONFIG_MODULE_COMPRESS_GZIP
>> +    mod_compress_cmd = gzip -n -9
>
> Please don't use gzip -9. The gain is very small, but it can make
> the time to compress much longer. Just use plain gzip.

Interesting:

$ time find * -name '*.ko' | xargs -n 1 gzip
real	0m9.404s
user	0m7.283s
sys	0m1.667s
$ du -c `find * -name '*.ko.gz'` | tail -n1
56412	total

time find * -name '*.ko' | xargs -n 1 gzip -9
real	1m1.968s
user	0m58.850s
sys	0m1.786s
$ du -c `find * -name '*.ko.gz'` | tail -n1
55764	total

$ time find * -name '*.ko' | xargs -n 1 xz
real	1m23.396s
user	1m13.893s
sys	0m9.134s
$ du -c `find * -name '*.ko.xz` | tail -n1
46868	total

$ time find * -name '*.ko' | xargs -n 1 xz -9
real	1m47.202s
user	1m25.962s
sys	0m21.298s
$ du -c `find * -name '*.ko.xz` | tail -n1
46868	total

So, Andi is right.  Please skip -9 for both options: it makes little
(.gz) or no (.xz) difference and it slows things down.

Cheers,
Rusty.
