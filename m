Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbbAMPXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:23:37 -0500
Received: from lists.s-osg.org ([54.187.51.154]:49516 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbbAMPXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:23:34 -0500
Message-ID: <54B53875.5020404@osg.samsung.com>
Date: Tue, 13 Jan 2015 08:23:33 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
CC: mpe@ellerman.id.au, benh@kernel.crashing.org, anton@samba.org,
        mikey@neuling.org
Subject: Re: [PATCH V2 07/12] selftests, powerpc: Add test for explicitly
 changing DSCR value
References: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com> <1421144560-15901-8-git-send-email-khandual@linux.vnet.ibm.com>
In-Reply-To: <1421144560-15901-8-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 03:22 AM, Anshuman Khandual wrote:
> This patch adds a test which modifies the DSCR using mtspr instruction
> and verifies the change using mfspr instruction. It uses both the
> privilege state SPR as well as the problem state SPR for the purpose.
> 
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  tools/testing/selftests/powerpc/dscr/Makefile      |  2 +-
>  .../selftests/powerpc/dscr/dscr_explicit_test.c    | 72 ++++++++++++++++++++++
>  2 files changed, 73 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/powerpc/dscr/dscr_explicit_test.c
> 
> diff --git a/tools/testing/selftests/powerpc/dscr/Makefile b/tools/testing/selftests/powerpc/dscr/Makefile
> index 0aa90ab..aede453 100644
> --- a/tools/testing/selftests/powerpc/dscr/Makefile
> +++ b/tools/testing/selftests/powerpc/dscr/Makefile
> @@ -1,4 +1,4 @@
> -PROGS := dscr_default_test
> +PROGS := dscr_default_test dscr_explicit_test
>  
>  CFLAGS := $(CFLAGS) -lpthread
>  
> diff --git a/tools/testing/selftests/powerpc/dscr/dscr_explicit_test.c b/tools/testing/selftests/powerpc/dscr/dscr_explicit_test.c
> new file mode 100644
> index 0000000..5c0b7c1
> --- /dev/null
> +++ b/tools/testing/selftests/powerpc/dscr/dscr_explicit_test.c
> @@ -0,0 +1,72 @@
> +/*
> + * POWER Data Stream Control Register (DSCR) explicit test
> + *
> + * This test modifies the DSCR value using mtspr instruction and
> + * verifies the change with mfspr instruction. It uses both the
> + * privilege state SPR and the problem state SPR for this purpose.
> + *
> + * When using the privilege state SPR, the instructions such as
> + * mfspr or mtspr are priviledged and the kernel emulates them
> + * for us. Instructions using problem state SPR can be exuecuted
> + * directly without any emulation if the HW supports them. Else
> + * they also get emulated by the kernel.
> + *
> + * Copyright (C) 2012 Anton Blanchard <anton@au.ibm.com>, IBM
> + * Copyright (C) 2015 Anshuman Khandual <khandual@linux.vnet.ibm.com>, IBM
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +#include "dscr.h"
> +
> +int test_body(void)
> +{
> +	unsigned long i, dscr = 0;
> +
> +	srand(getpid());
> +	set_dscr(dscr);
> +
> +	for (i = 0; i < COUNT; i++) {
> +		unsigned long cur_dscr, cur_dscr_usr;
> +		double ret = uniform_deviate(rand());
> +
> +		if (ret < 0.001) {
> +			dscr++;
> +			if (dscr > DSCR_MAX)
> +				dscr = 0;
> +
> +			set_dscr(dscr);
> +		}
> +
> +		cur_dscr = get_dscr();
> +		if (cur_dscr != dscr) {
> +			fprintf(stderr, "Kernel DSCR should be %ld but "
> +					"is %ld\n", dscr, cur_dscr);
> +			return 1;
> +		}
> +
> +		ret = uniform_deviate(rand());
> +		if (ret < 0.001) {
> +			dscr++;
> +			if (dscr > DSCR_MAX)
> +				dscr = 0;
> +
> +			set_dscr_usr(dscr);
> +		}
> +
> +		cur_dscr_usr = get_dscr_usr();
> +		if (cur_dscr_usr != dscr) {
> +			fprintf(stderr, "User DSCR should be %ld but "
> +					"is %ld\n", dscr, cur_dscr_usr);
> +			return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	return test_harness(test_body, "dscr_explicit_test");
> +}
> 

Could you please add a .gitignore for powerpc targets as we
discussed earlier. It can be separate patch.

Also, I would like to see the test results reports using
kselftest.h - it can be separate patch in the interest of
getting tests in.

Acked-by: Shuah Khan <shuahkh@osg.samsung.com>

Please take this through powerpc maintainer git.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
