Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3GJUyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:54:40 -0400
Received: from fieldses.org ([174.143.236.118]:35962 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908Ab3GJUyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:54:39 -0400
Date: Wed, 10 Jul 2013 16:54:34 -0400
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Anvin <hpa@zytor.com>
Subject: Re: scheduling while atomic & hang.
Message-ID: <20130710205434.GC22305@fieldses.org>
References: <20130704015525.GA8486@redhat.com>
 <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
 <20130704074902.GA32211@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130704074902.GA32211@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 03:49:02AM -0400, Dave Jones wrote:
> I don't use the auto config, because I end up filling up /boot
> unless I go through and clean them out by hand every time I install
> a new one (which I do probably a dozen or so times a day).
> Is there some easy way to prune old builds I'm missing ?

I run this by hand every now and then.  I'm probably doing it all wrong.

--b.

#!/bin/bash

# because I use CONFIG_LOCALVERSION_AUTO, not the same version again and
# again, /boot and /lib/modules/ eventually fill up.
# Dumb script to purge that stuff:

ssh "root@$1" '

for f in $(ls /lib/modules); do
        if rpm -qf "/lib/modules/$f" >/dev/null; then
                echo "keeping $f (installed from rpm)"
        elif [ $(uname -r) = "$f" ]; then
                echo "keeping $f (running kernel) "
        else
                echo "removing $f"
                rm -f "/boot/initramfs-$f.img" "/boot/System.map-$f"
                rm -f "/boot/vmlinuz-$f"   "/boot/config-$f"
                rm -rf "/lib/modules/$f"
                new-kernel-pkg --remove $f
        fi
done
'
