Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab3CDDzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:55:00 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:52212 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000Ab3CDDy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:54:57 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kees Cook <keescook@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Brad Spengler <spender@grsecurity.net>,
        Al Viro <viro@zeniv.linux.org.uk>, PaX Team <pageexec@freemail.hu>
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
	<20130303005700.GA32213@austin.hallyn.com>
	<874ngtxgt5.fsf@xmission.com>
	<CAGXu5j+bwUx6r++ttvYg4yJrUUHxoQ86tQ0JzEBoQQU6KAh9ww@mail.gmail.com>
	<874ngsrvrh.fsf@xmission.com>
	<CAGXu5jJiO=BmjVbpVJhxHbafn5T_SQbe5g-RLxRbmknNnQMyfQ@mail.gmail.com>
Date: Sun, 03 Mar 2013 19:54:48 -0800
In-Reply-To: <CAGXu5jJiO=BmjVbpVJhxHbafn5T_SQbe5g-RLxRbmknNnQMyfQ@mail.gmail.com>
	(Kees Cook's message of "Sun, 3 Mar 2013 18:35:28 -0800")
Message-ID: <87ip57om47.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+wN40amx+dQTnROJs9EUul2qlw/Mz6nVc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2410]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kees Cook <keescook@google.com>
X-Spam-Relay-Country: 
Subject: Re: user ns: arbitrary module loading
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@google.com> writes:

> On Sun, Mar 3, 2013 at 1:58 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:

> Ah-ha, thanks! Yes, that worked great. I think map_write()'s
> cap_valid/ns_capable calls confused me. :)

Yes permissions across user namespaces can be a little weird.  But
mostly if you are their creator, you are their all powerful god and
they must watch out.

>> For netdev at least I don't see it as being particularly interesting.
>> The case for tunnels is already as unprivileged as you can reasonably
>> get with "request_module("rtnl-link-%s", kind);" in
>> net/core/rtnetlink.c:rtnl_newlink().  For real physical devices there is
>> both greater chance of a buggy module and no realy need as udev will
>> load the module based on hardware auto-discovery.
>>
>> This leads to the fundamental question: Should we require privilege to
>> request the load filesystem modules?
>
> I think that the past dictated the need for privilege due to it being
> tied to mounting. With userns, this is weakened, but it seems like the
> privilege should at least attempt to segregate caps to certain classes
> of modules.

With filesystems in particular the attack surface is practically
non-existent if the filesystem is not mounted, and FS_USERNS_MOUNT
prevents most filesystems from being mounted.  So right now I do not see
any real danger in allowing filesystem modules to be auto-loaded.

>> I have looked at GRKERNSEC_MODHARDEN to see if that could give me some
>> guidance.  Unfortunately GRKERNSEC_MODHARDEN takes the position that fs
>> kernel modules are the only kernel modules that should ever auto-load
>> and only in very specific situations.  So I can't see that being the
>> normal kernel policy, especially since there are the sysctls
>
> Right -- modharden's basic goal is to block all non-root autoloading.
> It had to work around some corner-cases (mount being setuid, etc).

The mail goal appears to be disable module auto-loading and to log
a message.

>> /proc/sys/kernel/modprobe and /proc/sys/kernel/modules_disabled.
>
> Right -- this gives the granularity of "autoloading" and "loading"
> respectively, but there is no concept of "only privileged autoloading"
> in the current kernel.

As of the 3.8 patch when a module is loaded it does:

+#ifdef CONFIG_GRKERNSEC_MODHARDEN
+	{
+		char *p, *p2;
+
+		if (strstr(mod->args, "grsec_modharden_netdev")) {
+			printk(KERN_ALERT "grsec: denied auto-loading kernel module for a network device with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev-%.64s instead.", mod->name);
+			err = -EPERM;
+			goto free_modinfo;
+		} else if ((p = strstr(mod->args, "grsec_modharden_normal"))) {
+			p += sizeof("grsec_modharden_normal") - 1;
+			p2 = strstr(p, "_");
+			if (p2) {
+				*p2 = '\0';
+				printk(KERN_ALERT "grsec: denied kernel module auto-load of %.64s by uid %.9s\n", mod->name, p);
+				*p2 = '_';
+			}
+			err = -EPERM;
+			goto free_modinfo;
+		}
+	}
+#endif

Which simplifies to
	if (strstr(mod->args, "grsec_modharden_fs") != 0) {
		err = -EPERM;
		goto  free_modinfo;
	}

So perhaps it tries but there is not really a concept of privileged
processes being able to auto-load anything except fs modules. 

In general what I see GRKERNSEC_MODHARDEN implementing is a policy of
printing a logging a message instead of auto-loading any kernel modules.

> It seems to me that unpriv users shouldn't be able to arbitrarily load
> kernel modules, but if userns continues in this direction, there will
> always be a path to doing autoloading for each different subsystem's
> modules, ultimately leading to unpriv loading. Still, I think it's
> worth creating obvious subsystem aliases so userspace can more easily
> blacklist/whitelist things.

But I don't see any problem with uprivileged users being able to cause
the kernel to request kernel modules, as long as the request is clear
enough that modprobe can implement the desired policy.

>> Overall the basic policy building blocks for controlling which modules
>> are loaded seem solid and in use.  So I don't see any particular reason
>> why the kernel's default policy should not be to allow any users actions
>> to request modules.
>>
>> So I think I am going to scrap the change sitting in my development tree
>> to require capalbe(CAP_SYS_ADMIN) to load a filesystem module and just
>> go with my request_module("fs-%.*",...); change. That is simple and
>> seems to match the rest of the kernel.
>
> Agreed.

Eric

