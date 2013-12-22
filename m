Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3LVKiM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 05:38:12 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:51732 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3LVKiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 05:38:10 -0500
Message-ID: <52B6C10E.3070002@googlemail.com>
Date: Sun, 22 Dec 2013 11:38:06 +0100
From: Stefan Beller <stefanbeller@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Oren Laadan <orenl@cellrox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lxc-devel <lxc-devel@lists.sourceforge.net>,
        Serge Hallyn <serge@hallyn.com>,
        Eric Biederman <ebiederm@xmission.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5?= =?ISO-8859-1?Q?g?= 
	<arve@android.com>,
        Amir Goldstein <amir@cellrox.com>
Subject: Re: [PATCH 2/2] binder: implement namepsace support for Android binder
 driver
References: <cover.1387706794.git.orenl@cellrox.com> <45c5d62a35f19228a681f5be9834741baabfdb0d.1387706794.git.orenl@cellrox.com>
In-Reply-To: <45c5d62a35f19228a681f5be9834741baabfdb0d.1387706794.git.orenl@cellrox.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  #include <linux/uaccess.h>
>  #include <linux/vmalloc.h>
>  #include <linux/slab.h>
> +#include <linux/ipc_namespace.h>
>  #include <linux/pid_namespace.h>
>  
>  #include "binder.h"
>  #include "binder_trace.h"
>  
> +/*
> + * Using a private context manager for each binder namespace is sufficient
> + * to isolate between namespaces, because in binder all IPC must be realized
> + * via hanldes obtained from the context manager.

handles

> + *
> + * TODO: currently, most debugfs data is not tracked per binder namespaces.
> + * Except for "procs" which are properly virtualized, everything else is
> + * global, including stats, logs, and dead nodes.
> + */
> +struct binder_namespace {
> +	struct kref kref;
> +
> +	struct binder_node *context_mgr_node;
> +	kuid_t context_mgr_uid;
> +	int last_id;

