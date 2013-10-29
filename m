Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab3J2Qea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:34:30 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:34222 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3J2Qe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:34:29 -0400
MIME-Version: 1.0
In-Reply-To: <1383042632-7102-2-git-send-email-vfalico@redhat.com>
References: <1383042632-7102-1-git-send-email-vfalico@redhat.com>
	<1383042632-7102-2-git-send-email-vfalico@redhat.com>
Date: Tue, 29 Oct 2013 09:34:28 -0700
X-Google-Sender-Auth: me1gCZlfDyj6rbPPfwdUMto_MOM
Message-ID: <CA+55aFxt9KnmZnK5QdkPcpHNR+Ath5WTzhRibu5Y=xOhiz3fzA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] msi: free msi_desc entry only after we've released
 the kobject
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Veaceslav Falico <vfalico@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 3:30 AM, Veaceslav Falico <vfalico@redhat.com> wrote:
>                 /*
>                  * Its possible that we get into this path
>                  * When populate_msi_sysfs fails, which means the entries
>                  * were not registered with sysfs.  In that case don't
> -                * unregister them.
> +                * unregister them, and just free. Otherwise the
> +                * kobject->release will take care of freeing the entry via
> +                * msi_kobj_release().
>                  */
>                 if (entry->kobj.parent) {
>                         kobject_del(&entry->kobj);
>                         kobject_put(&entry->kobj);
> +               } else {
> +                       kfree(entry);
>                 }
> -
> -               list_del(&entry->list);
> -               kfree(entry);

So this code sequence still makes me very unhappy.

Why does not just a simple unconditional

        kobject_del(&entry->kobj);
        kobject_put(&entry->kobj);

work for the "not registered with sysfs" case? And if the sysfs code
really gets confused, why not

        if (entry->kobj.parent)
                kobject_del(&entry->kobj);
        kobject_put(&entry->kobj);

(btw, looking at the sysfs code, this looks *very* suspicious in
sysfs_remove_dir():

        struct sysfs_dirent *sd = kobj->sd;

        spin_lock(&sysfs_assoc_lock);
        kobj->sd = NULL;
        spin_unlock(&sysfs_assoc_lock);

and I would suggest that "sd = kobj->sd" should be done under the
lock, because otherwise the lock is kind of pointless..)

Greg?

                Linus
