Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbaDWRpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:45:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43662 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770AbaDWRpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:45:16 -0400
Date: Wed, 23 Apr 2014 19:45:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Generating .config from device tree [was Re: Hardware dependencies
 in Kconfig]
Message-ID: <20140423174514.GA24243@amd.pavel.ucw.cz>
References: <20140414145359.48b7337c@endymion.delvare>
 <20140414191143.GA26864@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20140414191143.GA26864@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> Ideally, the arch doesn't matter at all for a driver, only the
> infrastructure the driver depends on does.  So perhaps the

Actually, it would be nice if user was never asked for combination
that can be compiled, and kernel would support them, but there's no
such hardware.

For example, if I am configuring for Nokia N900, I pretty much know
all the devices -- not even USB host is officially supported, so this
machine is not extensible. Yet I'll have to answer about 1000
questions about config.

And ... we already have very accurate description of what hardware
Nokia N900 has -- in the device tree. Perhaps it would make sense to
generate hardware-dependend parts of config from device tree? [I'll
still need to answer questions like CONFIG_NFS but should
not have to answer CONFIG_DISPLAY_PANEL_SONY_ACX565AKM question.]

Anyway, script is attached, perhaps it is useful to someone. 

[And yes, I believe we should build CONFIG_FOO corresponds to
"ti,omap3-foo" database.]

Run it from linux directory, and modify 

        m.linux_path = "/data/l/linux-n900/"
        m.dtb_path = "arch/arm/boot/dts/omap3-n900.dtb"

to match your configuration.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--DocE+STaALJfprDB
Content-Type: text/x-python; charset=us-ascii
Content-Disposition: attachment; filename="dtsconfig.py"

#!/usr/bin/python
#
# Scripts for automatic kernel configuration from dts
# 
# Copyright 2014 Pavel Machek <pavel@ucw.cz>
# Distribute under GPLv2+
#

import os
import re

class DtsParser():
    def __init__(m):
        m.linux_path = "/data/l/linux-n900/"
        m.dtb_path = "arch/arm/boot/dts/omap3-n900.dtb"

    def find_files(m, match):
        l = os.popen("find "+m.linux_path+" -name '"+match+"'").readlines()
        return map(lambda s: s.rstrip(), l)
        

    def find_compatible(m):
        dts = os.popen("dtc -I dtb "+m.dtb_path).readlines()
        compatibles = {}
        for line in dts:
            match = re.match(".*compatible = ([^;]*);", line)
            if not match:
                continue
            l = match.group(1)
            for s in l.split('",'):
                s = re.sub('^[" ]*', '', s)
                s = re.sub('"$', '', s)
                compatibles[s] = 1

        m.compatibles = compatibles


    def find_drivers(m):
        drivers = {}
        for fname in m.find_files("*.c"):
            for line in open(fname, "r").readlines():
                for c in m.compatibles:
                    if re.match('.*"'+c+'".*', line):
                        m.compatibles[c] = 2
                        if not fname in drivers:
                            drivers[fname] = []
                        drivers[fname] += [ line ]
        m.drivers = drivers

    def find_configs(m):
        configs = {}
        m.found_drivers = {}
        for fname in m.drivers:
            makefile = fname.rstrip("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-.,_")
            makefile += "Makefile"
            basename = re.match("^.*/([a-zA-Z0-9-_,]*).c$", fname)
            if not basename:
                print "Can't find basename for ", fname
                continue
            basename = basename.group(1)
            print basename

            lines = open(makefile, "r").readlines()
            for l in lines:
                l = l.rstrip()
                c = re.match("^obj-\$\(([A-Z0-9_]*)\)[ 	]*\+= "+basename+".o$", l) 
                if c:
                    break
            if not c:
                print "Could not file config option for ", basename, " in ", makefile
                continue
            c = c.group(1)
            print "Have config option ", c
            configs[c] = fname
            m.found_drivers[fname] = c
        m.configs = configs

    def run(m):
        m.find_compatible()
        m.find_drivers()
        m.find_configs()

    def print_configs(m):
        for c in m.configs:
            print c
        for c in m.compatibles:
            if m.compatibles[c] != 2:
                print "Could not find driver for ", c
        
parser = DtsParser()
parser.run()
parser.print_configs()


#print parser.find_files("*.c")


--DocE+STaALJfprDB--
