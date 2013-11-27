Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab3K0C05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:26:57 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:43495 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3K0C0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:26:54 -0500
MIME-Version: 1.0
In-Reply-To: <1559825.A4S6KeB0yX@vostro.rjw.lan>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
	<CAE9FiQW0_0Mi1WLk2o0phdG22LC6imeO62LG7Jsn7D7e0e_Vhg@mail.gmail.com>
	<CAE9FiQVMQvLFnkoBRSv35f97mfYuSxwsct-Mv5-Hd4s-1QWW3Q@mail.gmail.com>
	<1559825.A4S6KeB0yX@vostro.rjw.lan>
Date: Tue, 26 Nov 2013 18:26:54 -0800
X-Google-Sender-Auth: v0eW-VF5XYf_rGaTbKcV0eGn4rE
Message-ID: <CAE9FiQXevSPmPEvxzXjC-CFhpYHic0v+vN5+JV3j5kmX-wv_GQ@mail.gmail.com>
Subject: Re: [PATCH v2 04/10] PCI: Destroy pci dev only once
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 5:24 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>
> So assume pci_destroy_dev() is called twice in parallel for the same dev
> by two different threads.  Thread 1 does the atomic_inc_and_test() and
> finds that it is OK to do the device_del() and put_device() which causes
> the device object to be freed.  Then thread 2 does the atomic_inc_and_test()
> on the already freed device object and crashes the kernel.
>
thread2 should still hold one extra reference.
that is in
  device_schedule_callback
     ==> sysfs_schedule_callback
         ==> kobject_get(kobj)

pci_destroy_dev for thread2 is called at this point.

and that reference will be released from
        sysfs_schedule_callback
        ==> kobject_put()...

Thanks

Yinghai
