Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbbAFIYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 03:24:12 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:37098 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbbAFIXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 03:23:46 -0500
MIME-Version: 1.0
In-Reply-To: <54AAE00B.1020809@osg.samsung.com>
References: <1420456786-5989-1-git-send-email-drysdale@google.com> <54AAE00B.1020809@osg.samsung.com>
From: David Drysdale <drysdale@google.com>
Date: Tue, 6 Jan 2015 08:23:25 +0000
Message-ID: <CAHse=S-v3T1nA8HpZOzsOqD5WZr8QTpcEy_kV=yk8uVJBOTGnw@mail.gmail.com>
Subject: Re: [PATCH] selftests/exec: allow shell return code of 126
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 7:03 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> On 01/05/2015 04:19 AM, David Drysdale wrote:
>> When the shell fails to invoke a script because its path name
>> is too long (ENAMETOOLONG), most shells return 127 to indicate
>> command not found.  However, some systems report 126 (which POSIX
>> suggests should indicate a non-executable file) for this case,
>> so allow that too.
>>
>> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Signed-off-by: David Drysdale <drysdale@google.com>
>> ---
>>  tools/testing/selftests/exec/execveat.c | 28 ++++++++++++++++++++++------
>>  1 file changed, 22 insertions(+), 6 deletions(-)
>>
>> diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
>> index d273624c93a6..0d940c6e26bd 100644
>> --- a/tools/testing/selftests/exec/execveat.c
>> +++ b/tools/testing/selftests/exec/execveat.c
>> @@ -62,7 +62,7 @@ static int _check_execveat_fail(int fd, const char *path, int flags,
>>  }
>>
>>  static int check_execveat_invoked_rc(int fd, const char *path, int flags,
>> -                                  int expected_rc)
>> +                                  int expected_rc, int expected_rc2)
>
> This logic doesn't scale well if there other expected return
> values to account for. Please think about a re-write to handle
> multiple expected return codes.

I don't think it needs to scale -- even having a second possible return
code was a bit of a surprise.

>>  {
>>       int status;
>>       int rc;
>> @@ -99,9 +99,19 @@ static int check_execveat_invoked_rc(int fd, const char *path, int flags,
>>               return 1;
>>       }
>>       if (WEXITSTATUS(status) != expected_rc) {
>> -             printf("[FAIL] (child %d exited with %d not %d)\n",
>> -                     child, WEXITSTATUS(status), expected_rc);
>> -             return 1;
>> +             if (expected_rc != expected_rc2) {
>
> Please collapse expected_rc and expected_rc2 checks. You can rephrase
> the error message to work for both cases.

OK, will do.

> thanks,
> -- Shuah
>
> --
> Shuah Khan
> Sr. Linux Kernel Developer
> Open Source Innovation Group
> Samsung Research America (Silicon Valley)
> shuahkh@osg.samsung.com | (970) 217-8978
