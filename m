Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaJSPbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 11:31:31 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35274 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaJSPb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 11:31:26 -0400
MIME-Version: 1.0
In-Reply-To: <54353E91.1040209@suse.cz>
References: <1411222524-7850-1-git-send-email-valentinrothberg@gmail.com>
 <1412010341-13902-1-git-send-email-valentinrothberg@gmail.com>
 <542C1692.5060007@suse.cz> <CAD3Xx4Kg82ugtN0RHOQNeDPW5Y7ymzm03NycmESztsVA4bJy8w@mail.gmail.com>
 <54353E91.1040209@suse.cz>
From: Valentin Rothberg <valentinrothberg@gmail.com>
Date: Sun, 19 Oct 2014 17:30:55 +0200
Message-ID: <CAD3Xx4K=BCaBmRxHiUwUmyPRSLrjiJZTJ2G6kyi8_RS8+5_A9g@mail.gmail.com>
Subject: Re: [PATCH v8] checkkconfigsymbols.sh: reimplementation in python
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-kbuild@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
        Stefan Hengelein <stefan.hengelein@fau.de>, gregkh@linuxfoundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 3:39 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 2014-10-04 11:29, Valentin Rothberg wrote:
>> On Wed, Oct 1, 2014 at 4:58 PM, Michal Marek <mmarek@suse.cz> wrote:
>>> On 2014-09-29 19:05, Valentin Rothberg wrote:
>>>> The scripts/checkkconfigsymbols.sh script searches Kconfig features
>>>> in the source code that are not defined in Kconfig. Such identifiers
>>>> always evaluate to false and are the source of various kinds of bugs.
>>>> However, the shell script is slow and it does not detect such broken
>>>> references in Kbuild and Kconfig files (e.g., ``depends on UNDEFINED´´).
>>>> Furthermore, it generates false positives. The script is also hard to
>>>> read and understand, and is thereby difficult to maintain.
>>>>
>>>> This patch replaces the shell script with an implementation in Python,
>>>> which:
>>>>     (a) detects the same bugs, but does not report previous false positives
>>>>     (b) additionally detects broken references in Kconfig and all
>>>>         non-Kconfig files, such as Kbuild, .[cSh], .txt, .sh, defconfig, etc.
>>>>     (c) is up to 75 times faster than the shell script
>>>>     (d) only checks files under version control ('git ls-files')
>>>>
>>>> The new script reduces the runtime on my machine (i7-2620M, 8GB RAM, SSD)
>>>> from 3m47s to 0m3s, and reports 912 broken references in Linux v3.17-rc1;
>>>> 424 additional reports of which 16 are located in Kconfig files,
>>>> 287 in defconfigs, 63 in ./Documentation, 1 in Kbuild.
>>>>
>>>> Moreover, we intentionally include references in comments, which have been
>>>> ignored until now. Such comments may be leftovers of features that have
>>>> been removed or renamed in Kconfig (e.g., ``#endif /* CONFIG_MPC52xx */´´).
>>>> These references can be misleading and should be removed or replaced.
>>>>
>>>> Note that the output format changed from (file list <tab> feature) to
>>>> (feature <tab> file list) as it simplifies the detection of the Kconfig
>>>> feature for long file lists.
>>>>
>>>> Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
>>>> Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
>>>> Acked-by: Paul Bolle <pebolle@tiscali.nl>
>>>> ---
>>>> Changelog:
>>>> v2: Fix of regular expressions
>>>> v3: Changelog replacement, and add changes of v2
>>>> v4: Based on comments from Paul Bolle <pebolle@tiscali.nl>
>>>>   - Inclusion of all non-Kconfig files, such as .txt, .sh, etc.
>>>>   - Changes of regular expressions
>>>>   - Increases additional reports from 49 to 229 compared to v3
>>>>   - Change of output format from (file list <tab> feature) to
>>>>         (feature <tab> file list)
>>>> v5: Only analyze files under version control ('git ls-files')
>>>> v6: Cover features with numbers and small letters (e.g., 4xx)
>>>> v7: Add changes of v6 (lost 'git add') and filter FOO/BAR features
>>>> v8: Based on comments from Paul Bolle <pebolle@tiscali.nl>
>>>>   - Fix of [D]{,1}CONFIG_ regex to exclude false positives
>>>>   - Exclude ".log" files of analysis
>>>>   - Filter "XXX" feature
>>>> ---
>>>>  scripts/checkkconfigsymbols.py | 139 +++++++++++++++++++++++++++++++++++++++++
>>>>  scripts/checkkconfigsymbols.sh |  59 -----------------
>>>>  2 files changed, 139 insertions(+), 59 deletions(-)
>>>>  create mode 100644 scripts/checkkconfigsymbols.py
>>>>  delete mode 100755 scripts/checkkconfigsymbols.sh
>>>
>>> Please make the new file executable as well.
>>>
>>>
>>>> +    for gitfile in stdout.rsplit("\n"):
>>>> +        if ".git" in gitfile or "ChangeLog" in gitfile or \
>>>> +                ".log" in gitfile or os.path.isdir(gitfile):
>>>> +            continue
>>>
>>> Can you also skip arch/*/configs? A significant part of the output are
>>> defconfig files, but there is little value in reporting them. The stale
>>> options will go away automatically as soon as the defconfig is refreshed.
>>
>> What do you mean by "refreshed"?
>
> Generated again with new Kconfig data.
>
>
>> And how often are they refreshed? I
>> think that reporting defconfigs helps to point to a problem, namely
>> that features are just not present anymore.
>
> Any given defconfig is outdated most of the time, so you could as well
> list them all :). In most of the cases, it does not matter though,
> thanks to the defaults in Kconfig files.

I talked with Greg about this issue on Linux Plumbers last week in
Dusseldorf. It seems that there are people sending and accepting
patches which address exactly the problem of outdated Kconfig options
in defconfigs.

Michal, I understand your arguments, but I feel that reporting
defconfigs would help people doing this kind of work. As a
consequence, I suggest to keep the patch as it is and wait for
feedback. In case defconfigs are too annoying, we can still change it
later.

What do you think?

Valentin
