Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbbAETDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:03:44 -0500
Received: from lists.s-osg.org ([54.187.51.154]:42755 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108AbbAETDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:03:42 -0500
Message-ID: <54AAE00B.1020809@osg.samsung.com>
Date: Mon, 05 Jan 2015 12:03:39 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Drysdale <drysdale@google.com>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andreas Schwab <schwab@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
        linux-api@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH] selftests/exec: allow shell return code of 126
References: <1420456786-5989-1-git-send-email-drysdale@google.com>
In-Reply-To: <1420456786-5989-1-git-send-email-drysdale@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 04:19 AM, David Drysdale wrote:
> When the shell fails to invoke a script because its path name
> is too long (ENAMETOOLONG), most shells return 127 to indicate
> command not found.  However, some systems report 126 (which POSIX
> suggests should indicate a non-executable file) for this case,
> so allow that too.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: David Drysdale <drysdale@google.com>
> ---
>  tools/testing/selftests/exec/execveat.c | 28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
> index d273624c93a6..0d940c6e26bd 100644
> --- a/tools/testing/selftests/exec/execveat.c
> +++ b/tools/testing/selftests/exec/execveat.c
> @@ -62,7 +62,7 @@ static int _check_execveat_fail(int fd, const char *path, int flags,
>  }
>  
>  static int check_execveat_invoked_rc(int fd, const char *path, int flags,
> -				     int expected_rc)
> +				     int expected_rc, int expected_rc2)

This logic doesn't scale well if there other expected return
values to account for. Please think about a re-write to handle
multiple expected return codes.


>  {
>  	int status;
>  	int rc;
> @@ -99,9 +99,19 @@ static int check_execveat_invoked_rc(int fd, const char *path, int flags,
>  		return 1;
>  	}
>  	if (WEXITSTATUS(status) != expected_rc) {
> -		printf("[FAIL] (child %d exited with %d not %d)\n",
> -			child, WEXITSTATUS(status), expected_rc);
> -		return 1;
> +		if (expected_rc != expected_rc2) {

Please collapse expected_rc and expected_rc2 checks. You can rephrase
the error message to work for both cases.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
