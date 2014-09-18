Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbaIRNH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:07:29 -0400
Received: from lists.s-osg.org ([54.187.51.154]:36570 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbaIRNH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:07:27 -0400
Message-ID: <541AD905.6000700@osg.samsung.com>
Date: Thu, 18 Sep 2014 07:07:17 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v4 1/4] ftracetest: Initial commit for ftracetest
References: <20140918120437.28308.72301.stgit@kbuild-f20.novalocal> <20140918120445.28308.57538.stgit@kbuild-f20.novalocal>
In-Reply-To: <20140918120445.28308.57538.stgit@kbuild-f20.novalocal>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 06:04 AM, Masami Hiramatsu wrote:
> ftracetest is a collection of testcase shell-scripts for ftrace.
> To avoid regressions of ftrace, these testcases check correct
> ftrace behaviors. If someone would like to add any features on
> ftrace, the patch series should have at least one testcase for
> checking the new behavior.
> 
> Changes in v4:
>  - Move this under selftests. :)
>  - Add a copyright and note of GPLv2.
>  - Fix documents acconding to Steven's comments.
>  - Fix a small bug pointed by Namhyng.
> 
> Changes in v3:
>  - Use "." instead of "source".
>  - Don't use -e option for echo since dash doesn't support it.
> 
> Changes in v2:
>  - Remove unneeded 'function' keyword.
>  - Add abspath and find_testcases.
>  - Make OPT_TEST_CASES a local var.
>  - Ensure given testcase ended with .tc.
>  - Accept a directory option which has multiple testcases.
>  - Change [PASSED]/[FAILED] to [PASS]/[FAIL]
>  - Change the basic shell to sh (dash).
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  MAINTAINERS                                    |    1 
>  tools/testing/selftests/Makefile               |    1 
>  tools/testing/selftests/ftrace/Makefile        |    7 +
>  tools/testing/selftests/ftrace/README          |   46 +++++++
>  tools/testing/selftests/ftrace/ftracetest      |  157 ++++++++++++++++++++++++
>  tools/testing/selftests/ftrace/test.d/template |    4 +
>  6 files changed, 216 insertions(+)
>  create mode 100644 tools/testing/selftests/ftrace/Makefile
>  create mode 100644 tools/testing/selftests/ftrace/README
>  create mode 100755 tools/testing/selftests/ftrace/ftracetest
>  create mode 100644 tools/testing/selftests/ftrace/test.d/template
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5e7866a..29e22db 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9295,6 +9295,7 @@ F:	include/*/ftrace.h
>  F:	include/linux/trace*.h
>  F:	include/trace/
>  F:	kernel/trace/
> +F:	tools/testing/selftests/ftrace
>  
>  TRIVIAL PATCHES
>  M:	Jiri Kosina <trivial@kernel.org>
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 36ff2e4..45f145c 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -14,6 +14,7 @@ TARGETS += powerpc
>  TARGETS += user
>  TARGETS += sysctl
>  TARGETS += firmware
> +TARGETS += ftrace
>  
>  TARGETS_HOTPLUG = cpu-hotplug
>  TARGETS_HOTPLUG += memory-hotplug
> diff --git a/tools/testing/selftests/ftrace/Makefile b/tools/testing/selftests/ftrace/Makefile
> new file mode 100644
> index 0000000..76cc9f1
> --- /dev/null
> +++ b/tools/testing/selftests/ftrace/Makefile
> @@ -0,0 +1,7 @@
> +all:
> +
> +run_tests:
> +	@/bin/sh ./ftracetest || echo "ftrace selftests: [FAIL]"
> +
> +clean:
> +	rm -rf logs/*
> diff --git a/tools/testing/selftests/ftrace/README b/tools/testing/selftests/ftrace/README
> new file mode 100644
> index 0000000..ee2cef7
> --- /dev/null
> +++ b/tools/testing/selftests/ftrace/README
> @@ -0,0 +1,46 @@
> +Linux Ftrace Testcases
> +
> +This is a collection of testcases for ftrace tracing feature in the Linux
> +kernel. Since ftrace exports interfaces via the debugfs, we just need
> +shell scripts for testing. Feel free to add new test cases.
> +
> +Running the ftrace testcases
> +============================
> +
> +At first, you need to be the root user to run this script.
> +To run all testcases:
> +
> +  $ sudo ./ftracetest
> +
> +To run specific testcases:
> +
> +  # ./ftracetest test.d/basic3.tc
> +
> +Or you can also run testcases under given directory:
> +
> +  # ./ftracetest test.d/kprobe/
> +
> +Contributing new testcases
> +==========================
> +
> +Copy test.d/template to your testcase (whose filename must have *.tc
> +extension) and rewrite the test description line.
> +
> + * The working directory of the script is <debugfs>/tracing/.
> +
> + * Take care with side effects as the tests are run with root privilege.
> +
> + * The tests should not run for a long period of time (more than 1 min.)
> +   These are to be unit tests.
> +
> + * You can add a directory for your testcases under test.d/ if needed.
> +
> + * The test cases should run on dash (busybox shell) for testing on
> +   minimal cross-build environments.
> +
> +TODO
> +====
> +
> + * Fancy colored output :)
> +
> + * Integrate with selftest?

The second TODO can be removed since it is moved under selftests??
If you haven't already done this, could you please make sure it
runs without hangs when run from the "make kselftest" target.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
