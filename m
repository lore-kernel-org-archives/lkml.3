Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3IESsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 14:48:19 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:63571 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab3IESsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 14:48:17 -0400
MIME-Version: 1.0
In-Reply-To: <521C0F07.6030102@schaufler-ca.com>
References: <20130806063002.GF2280@outflux.net>
	<520177E8.5080906@schaufler-ca.com>
	<CAGXu5jL6dtB0F7fPh17pyhD22q0Q9Nn=wxbPf5AMYsrJuTvvJA@mail.gmail.com>
	<521C0F07.6030102@schaufler-ca.com>
Date: Thu, 5 Sep 2013 11:48:16 -0700
X-Google-Sender-Auth: 1QkftlM5W1qFJW_HwXaeqoTCoNQ
Message-ID: <CAGXu5jJmJu5Ram_x51kk2eoFOrS-v7SWernXUM_azdXdxzMLVA@mail.gmail.com>
Subject: Re: [PATCH v14 0/6] LSM: Multiple concurrent LSMs
From: Kees Cook <keescook@chromium.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 7:29 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 8/6/2013 3:36 PM, Kees Cook wrote:
>> On Tue, Aug 6, 2013 at 3:25 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>>> On 8/5/2013 11:30 PM, Kees Cook wrote:
>>>> On Thu, Jul 25, 2013 at 11:52 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>>> The /proc/*/attr interfaces are given to one LSM. This can be
>>>>> done by setting CONFIG_SECURITY_PRESENT. Additional interfaces
>>>>> have been created in /proc/*/attr so that each LSM has its own
>>>>> named interfaces. The name of the presenting LSM can be read from
>>>> For me, this is one problem that was bothering me, but it was a cosmetic
>>>> one that I'd mentioned before: I really disliked the /proc/$pid/attr
>>>> interface being named "$lsm.$file". I feel it's important to build
>>>> directories in attr/ for each LSM. So, I spent time to figure out a way to
>>>> do this. This patch changes the interface to /proc/$pid/attr/$lsm/$file
>>>> instead, which I feel has a much more appealing organizational structure.
>>> I will confess that the reason I went with <lsm>.current instead of
>>> <lsm>/current was that the former was easier to implement.
>> Yeah, that's totally fine. It wasn't very obvious (to me) how to
>> implement this initially, so no problem at all. I'm glad there was
>> something more than bug fixes I could contribute to this series. :)
>
> Oh dear. I'm rebasing for 3.12 and the macros don't generate compiling
> code any longer. It seems that, among other things, readdir is no longer
> a member of file_operations.

Looks like f0c3b5093addc8bfe9fe3a5b01acb7ec7969eafa is what touched
fs/proc/base.c and it should just need a few tweaks from "readdir"
becoming "iterate", and the prototype changing.

So it should just require bump the macros a little. Let's see if gmail
eats my paste...

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 4c80ffd..f670349 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2358,17 +2358,17 @@ static const struct file_operations proc_pid_attr_operat
 };

 #define LSM_DIR_OPS(LSM) \
-static int proc_##LSM##_attr_dir_readdir(struct file * filp, \
-                            void * dirent, filldir_t filldir) \
+static int proc_##LSM##_attr_dir_iterate(struct file * filp, \
+                            struct dir_context *ctx) \
 { \
-       return proc_pident_readdir(filp, dirent, filldir, \
+       return proc_pident_readdir(filp, ctx, \
                                   LSM##_attr_dir_stuff, \
                                   ARRAY_SIZE(LSM##_attr_dir_stuff)); \
 } \
 \
 static const struct file_operations proc_##LSM##_attr_dir_ops = { \
        .read           = generic_read_dir, \
-       .readdir        = proc_##LSM##_attr_dir_readdir, \
+       .iterate        = proc_##LSM##_attr_dir_iterate, \
        .llseek         = default_llseek, \
 }; \
 \


Do you have the rest of the series already ported to 3.12?

-Kees

-- 
Kees Cook
Chrome OS Security
