Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbbAMPYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:24:06 -0500
Received: from lists.s-osg.org ([54.187.51.154]:49535 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbbAMPYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:24:03 -0500
Message-ID: <54B53892.8060202@osg.samsung.com>
Date: Tue, 13 Jan 2015 08:24:02 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
CC: mpe@ellerman.id.au, benh@kernel.crashing.org, anton@samba.org,
        mikey@neuling.org
Subject: Re: [PATCH V2 09/12] selftests, powerpc: Add test for DSCR value
 inheritence across fork
References: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com> <1421144560-15901-10-git-send-email-khandual@linux.vnet.ibm.com>
In-Reply-To: <1421144560-15901-10-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 03:22 AM, Anshuman Khandual wrote:
> This patch adds a test to verify that the changed DSCR value inside
> any process would be inherited to it's child process across the fork
> system call.
> 
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  tools/testing/selftests/powerpc/dscr/Makefile      |  3 +-
>  .../selftests/powerpc/dscr/dscr_inherit_test.c     | 96 ++++++++++++++++++++++
>  2 files changed, 98 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/powerpc/dscr/dscr_inherit_test.c
> 
> diff --git a/tools/testing/selftests/powerpc/dscr/Makefile b/tools/testing/selftests/powerpc/dscr/Makefile
> index ae865d8..81239e2 100644
> --- a/tools/testing/selftests/powerpc/dscr/Makefile
> +++ b/tools/testing/selftests/powerpc/dscr/Makefile
> @@ -1,4 +1,5 @@
> -PROGS := dscr_default_test dscr_explicit_test dscr_user_test
> +PROGS := dscr_default_test dscr_explicit_test dscr_user_test	\
> +	 dscr_inherit_test
>  
>  CFLAGS := $(CFLAGS) -lpthread
>  
> diff --git a/tools/testing/selftests/powerpc/dscr/dscr_inherit_test.c b/tools/testing/selftests/powerpc/dscr/dscr_inherit_test.c
> new file mode 100644
> index 0000000..f1add77
> --- /dev/null
> +++ b/tools/testing/selftests/powerpc/dscr/dscr_inherit_test.c
> @@ -0,0 +1,96 @@
> +/*
> + * POWER Data Stream Control Register (DSCR) fork test
> + *
> + * This testcase modifies the DSCR using mtspr, forks and then
> + * verifies that the child process has the correct changed DSCR
> + * value using mfspr.
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
> +	pid_t pid;
> +
> +	srand(getpid());
> +	set_dscr(dscr);
> +
> +	for (i = 0; i < COUNT; i++) {
> +		unsigned long cur_dscr, cur_dscr_usr;
> +
> +		dscr++;
> +		if (dscr > DSCR_MAX)
> +			dscr = 0;
> +
> +		if (i % 2 == 0)
> +			set_dscr_usr(dscr);
> +		else
> +			set_dscr(dscr);
> +
> +		/*
> +		 * XXX: Force a context switch out so that DSCR
> +		 * current value is copied into the thread struct
> +		 * which is required for the child to inherit the
> +		 * changed value.
> +		 */
> +		sleep(1);
> +
> +		pid = fork();
> +		if (pid == -1) {
> +			perror("fork() failed\n");
> +			exit(1);
> +		} else if (pid) {
> +			int status;
> +
> +			if (waitpid(pid, &status, 0) == -1) {
> +				perror("waitpid() failed\n");
> +				exit(1);
> +			}
> +
> +			if (!WIFEXITED(status)) {
> +				fprintf(stderr, "Child didn't exit cleanly\n");
> +				exit(1);
> +			}
> +
> +			if (WEXITSTATUS(status) != 0) {
> +				fprintf(stderr, "Child didn't exit cleanly\n");
> +				return 1;
> +			}
> +		} else {
> +			cur_dscr = get_dscr();
> +			if (cur_dscr != dscr) {
> +				fprintf(stderr, "Kernel DSCR should be %ld "
> +					"but is %ld\n", dscr, cur_dscr);
> +				exit(1);
> +			}
> +
> +			cur_dscr_usr = get_dscr_usr();
> +			if (cur_dscr_usr != dscr) {
> +				fprintf(stderr, "User DSCR should be %ld "
> +					"but is %ld\n", dscr, cur_dscr_usr);
> +				exit(1);
> +			}
> +			exit(0);
> +		}
> +	}
> +	return 0;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	return test_harness(test_body, "dscr_inherit_test");
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
