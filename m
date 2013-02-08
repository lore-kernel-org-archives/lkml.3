Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068Ab3BHKGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 05:06:02 -0500
Received: from ozlabs.org ([203.10.76.45]:53999 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab3BHKGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 05:06:00 -0500
Message-ID: <5114CE00.6050307@ozlabs.org>
Date: Fri, 08 Feb 2013 18:05:52 +0800
From: Jeremy Kerr <jk@ozlabs.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Lingzhu Xiang <lxiang@redhat.com>, Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 1/3 v3] selftests: Add tests for efivarfs
References: <1360162088.142733.191120808822.0.gpush@pecola> <1360162088.143076.913706486688.1.gpush@pecola> <20130207151333.f01d415c.akpm@linux-foundation.org>
In-Reply-To: <20130207151333.f01d415c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks for taking a look at these.

>> @@ -1,4 +1,4 @@
>> -TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug
>> +TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug efivarfs
>
> bah.  This sort of Makefile construct is a wonderful source of patch
> rejects and fixups.  I'll covert this to
>
> --- a/tools/testing/selftests/Makefile~a
> +++ a/tools/testing/selftests/Makefile
> @@ -1,4 +1,11 @@
> -TARGETS = breakpoints epoll kcmp mqueue vm cpu-hotplug memory-hotplug efivarfs
> +TARGETS = breakpoints
> +TARGETS += epoll
> +TARGETS += kcmp
> +TARGETS += mqueue
> +TARGETS += vm
> +TARGETS += cpu-hotplug
> +TARGETS += memory-hotplug
> +TARGETS += efivarfs

Much better, thanks. I'd already had a collision with the epoll tests...

> I'll do this for now:
>
> --- a/tools/testing/selftests/efivarfs/Makefile~selftests-add-tests-for-efivarfs-fix
> +++ a/tools/testing/selftests/efivarfs/Makefile
> @@ -6,7 +6,7 @@ test_objs = open-unlink
>   all: $(test_objs)
>
>   run_tests: all
> -	@./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
> +	@/bin/sh ./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
>
>   clean:
>   	rm -f $(test_objs)
>
> but I'm not sure I did it right :(

efivarfs.sh requires bash currently, so we'll need to call this explicitly:

+	@/bin/bash ./efivarfs.sh || echo "efivarfs selftests: [FAIL]"

Is this okay?

> The general ruleset for selftests is: do as much as you can if you're not
> root and don't take too long and don't break the build on any
> architecture and don't cause the top-level "make run_tests" to fail if
> your feature is unconfigured.

Ah, good stuff to know. I'll send a patch adding this info to 
Documentation/ too.

> Does this code pass all that?

It should, yes:

  * all test requires root at present, as all efivarfs files are only
    writable by root

  * the built binaries doesn't use anything more than basic C, so should
    build fine wherever we have gcc.

  * efivarfs.sh will skip all tests if efivarfs is not mounted

However, the tests expose a bug at the moment, so run_tests will fail. 
Matt will have that fixed soon though :)

Cheers,


Jeremy


