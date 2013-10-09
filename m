Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab3JIRHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:07:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:35709 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab3JIRH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:07:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1064,1371106800"; 
   d="jpg'145?scan'145,208,145";a="372478121"
Date: Wed, 9 Oct 2013 10:07:22 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] tools/thermal: Introduce tmon, a tool for thermal
 subsystem
Message-ID: <20131009100722.5f2e10a8@ultegra>
In-Reply-To: <52558535.3010506@ti.com>
References: <1381259024-25433-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<52558535.3010506@ti.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/m36g8KMQBxpMMIjZkVoJuET"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/m36g8KMQBxpMMIjZkVoJuET
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, 9 Oct 2013 12:32:53 -0400
Eduardo Valentin <eduardo.valentin@ti.com> wrote:

> On 08-10-2013 15:03, Jacob Pan wrote:
> > Increasingly, Linux is running on thermally constrained devices.
> > The simple thermal relationship between processor and fan has
> > become past for modern computers.
> > 
> > As hardware vendors cope with the thermal constraints on their
> > products, more sensors are added, new cooling capabilities are
> > introduced. The complexity of the thermal relationship can grow
> > exponentially among cooling devices, zones, sensors, and trip
> > points. They can also change dynamically.
> > 
> > To expose such relationship to the userspace, Linux generic thermal
> > layer introduced sysfs entry at /sys/class/thermal with a matrix of
> > symbolic links, trip point bindings, and device instances. To
> > traverse such matrix by hand is not a trivial task. Testing is also
> > difficult in that thermal conditions are often exception cases that
> > hard to reach in normal operations.
> > 
> > TMON is conceived as a tool to help visualize, tune, and test the
> > complex thermal subsystem.
> > 
> 
> Jacob, I have a major point for discussion on the concept you are
> presenting and the target of this tool. The tool, based on its name
> and this patch description is target to monitor, visualize and test
> the thermal aspects. But in fact you are also adding a PID controller
> embedded in this tool, which is contradicting to your proposal, don't
> you agree?
> 
I agree, it was started as monitoring only. any suggestions? perhaps
call it thermaltop?
> However, I am not saying a PID is a bad thing, in fact, it is the
> opposite. I have on my todo list create a thermal governor based on a
> simple PID controller. Perhaps we should work together on that fron.
> Have you considered posting the PID part as a thermal governor?
> 
That is a good suggestion. The challenge of PID is the tuning of its
parameters which are platform specific. Leaving it completely with
userspace will make it hard to use and not practical. We can tune PID at
runtime automatically with stimulus such as step response but must be
done with user discretion.
My thinking is that we take a stepped approach.
1. Make a tool such as TMON which can be used for tuning PID parameters
2. Introduce a PID governor which can accept TMON's tuning results
3. some userspace scheme to make the tuning results persistent across
boots.
> Another side question is how you are testing or what are the test
> cases you are using to validate your PID.
> 
I am using two test cases
1. step response test
with a step type stimulus (cpu busy spin test) to see the response with
using one cooling device. e.g. use powerclamp to control CPU
temperature.
2. dynamic test, compile a kernel under 60C

I look at the rise time, steady state error, over shoot etc. I have
attached a graph of TMON data ploted with Rscript.

But the tuning of PID parameters need to be done in the future. Right
now, it is fixed.

> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >  tools/thermal/tmon/Makefile |   47 ++++
> >  tools/thermal/tmon/README   |   50 ++++
> >  tools/thermal/tmon/pid.c    |  131 +++++++++
> >  tools/thermal/tmon/sysfs.c  |  585
> > +++++++++++++++++++++++++++++++++++++++ tools/thermal/tmon/tmon.8
> > |  142 ++++++++++
> 
> What is this file? It does not seam to be used at all and it is not
> documented.
this is a man page file.
see how to use tmon with "man tmon.8"
> 
> >  tools/thermal/tmon/tmon.c   |  350 ++++++++++++++++++++++++
> >  tools/thermal/tmon/tmon.h   |  204 ++++++++++++++
> >  tools/thermal/tmon/tui.c    |  631
> > +++++++++++++++++++++++++++++++++++++++++++ 8 files changed, 2140
> > insertions(+) create mode 100644 tools/thermal/tmon/Makefile
> >  create mode 100644 tools/thermal/tmon/README
> >  create mode 100644 tools/thermal/tmon/pid.c
> >  create mode 100644 tools/thermal/tmon/sysfs.c
> >  create mode 100644 tools/thermal/tmon/tmon.8
> >  create mode 100644 tools/thermal/tmon/tmon.c
> >  create mode 100644 tools/thermal/tmon/tmon.h
> >  create mode 100644 tools/thermal/tmon/tui.c
> > 
> > diff --git a/tools/thermal/tmon/Makefile
> > b/tools/thermal/tmon/Makefile new file mode 100644
> > index 0000000..c17131b
> > --- /dev/null
> > +++ b/tools/thermal/tmon/Makefile
> > @@ -0,0 +1,47 @@
> > +VERSION = 1.0
> > +
> > +BINDIR=usr/bin
> > +WARNFLAGS=-Wall -Wshadow -W -Wformat
> > -Wimplicit-function-declaration -Wimplicit-int +CFLAGS= -O1
> > ${WARNFLAGS} -fstack-protector +CC=gcc
> > +
> > +CFLAGS+=-D VERSION=\"$(VERSION)\"
> > +LDFLAGS+=
> > +TARGET=tmon
> > +
> > +INSTALL_PROGRAM=install -m 755 -p
> > +DEL_FILE=rm -f
> > +
> > +INSTALL_CONFIGFILE=install -m 644 -p
> > +CONFIG_FILE=
> > +CONFIG_PATH=
> > +
> > +
> > +OBJS = tmon.o tui.o sysfs.o pid.o
> > +OBJS +=
> > +
> > +tmon: $(OBJS) Makefile tmon.h
> > +	$(CC) ${CFLAGS} $(LDFLAGS) $(OBJS)  -o $(TARGET)
> > -lncursesw -lm -lpanel -lpthread +
> > +valgrind: tmon
> > +	 sudo valgrind -v --track-origins=yes --tool=memcheck
> > --leak-check=yes --show-reachable=yes --num-callers=20
> > --track-fds=yes ./$(TARGET)  1> /dev/null + +install:
> > +	- mkdir -p $(INSTALL_ROOT)/$(BINDIR)
> > +	- $(INSTALL_PROGRAM) "$(TARGET)"
> > "$(INSTALL_ROOT)/$(BINDIR)/$(TARGET)"
> > +	- mkdir -p $(INSTALL_ROOT)/$(CONFIG_PATH)
> > +	- $(INSTALL_CONFIGFILE) "$(CONFIG_FILE)"
> > "$(INSTALL_ROOT)/$(CONFIG_PATH)" +
> > +uninstall:
> > +	$(DEL_FILE) "$(INSTALL_ROOT)/$(BINDIR)/$(TARGET)"
> > +	$(CONFIG_FILE) "$(CONFIG_PATH)"
> > +
> > +
> > +clean:
> > +	find . -name "*.o" | xargs $(DEL_FILE)
> > +	rm -f $(TARGET)
> > +
> > +dist:
> > +	git tag v$(VERSION)
> > +	git archive --format=tar --prefix="$(TARGET)-$(VERSION)/"
> > v$(VERSION) | \
> > +		gzip > $(TARGET)-$(VERSION).tar.gz
> > diff --git a/tools/thermal/tmon/README b/tools/thermal/tmon/README
> > new file mode 100644
> > index 0000000..4579498
> > --- /dev/null
> > +++ b/tools/thermal/tmon/README
> > @@ -0,0 +1,50 @@
> > +TMON - A Monitoring and Testing Tool for Linux kernel thermal
> > subsystem +
> > +Why TMON?
> > +==========
> > +Increasingly, Linux is running on thermally constrained devices.
> > The simple +thermal relationship between processor and fan has
> > become past for modern +computers.
> > +
> > +As hardware vendors cope with the thermal constraints on their
> > products, more +and more sensors are added, new cooling
> > capabilities are introduced. The +complexity of the thermal
> > relationship can grow exponentially among cooling +devices, zones,
> > sensors, and trip points. They can also change dynamically. +
> > +To expose such relationship to the userspace, Linux generic
> > thermal layer +introduced sysfs entry at /sys/class/thermal with a
> > matrix of symbolic +links, trip point bindings, and device
> > instances. To traverse such +matrix by hand is not a trivial task.
> > Testing is also difficult in that +thermal conditions are often
> > exception cases that hard to reach in +normal operations.
> > +
> > +TMON is conceived as a tool to help visualize, tune, and test the
> > +complex thermal subsystem.
> > +
> > +Files
> > +=====
> > +	tmon.c : main function for set up and configurations.
> > +	tui.c : handles ncurses based user interface
> > +	sysfs.c : access to the generic thermal sysfs
> > +	pid.c : a proportional-integral-derivative (PID) controller
> > +	that can be used for thermal relationship training.
> > +
> > +Requirements
> > +============
> > +Depends on ncurses
> > +
> > +Build
> > +=========
> > +$ make
> > +$ sudo ./tmon -h
> > +Usage: tmon [OPTION...]
> > +  -c, --control         cooling device in control
> > +  -d, --daemon          run as daemon, no TUI
> > +  -l, --log             log data to /var/tmp/tmon.log
> > +  -h, --help            show this help message
> > +  -t, --time-interval   set time interval for sampling
> > +  -v, --version         show version
> > +  -g, --debug           debug message in syslog
> > +
> > +1. For monitoring only:
> > +$ sudo ./tmon
> > diff --git a/tools/thermal/tmon/pid.c b/tools/thermal/tmon/pid.c
> > new file mode 100644
> > index 0000000..fd7e9e9
> > --- /dev/null
> > +++ b/tools/thermal/tmon/pid.c
> > @@ -0,0 +1,131 @@
> > +/*
> > + * pid.c PID controller for testing cooling devices
> > + *
> > + *
> > + *
> > + * Copyright (C) 2012 Intel Corporation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > version
> > + * 2 or later as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * Author Name Jacob Pan <jacob.jun.pan@linux.intel.com>
> > + *
> > + */
> > +
> > +#include <unistd.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <stdint.h>
> > +#include <sys/types.h>
> > +#include <dirent.h>
> > +#include <libintl.h>
> > +#include <ctype.h>
> > +#include <assert.h>
> > +#include <time.h>
> > +#include <limits.h>
> > +#include <math.h>
> > +#include <sys/stat.h>
> > +#include <syslog.h>
> > +
> > +#include "tmon.h"
> > +
> > +/**************************************************************************
> > + * PID (Proportional-Integral-Derivative) controller is commonly
> > used in
> > + * linear control system, consider the the process.
> > + * G(s) = U(s)/E(s)
> > + * kp = proportional gain
> > + * ki = integral gain
> > + * kd = derivative gain
> > + * Ts
> > + * We use type C Alan Bradley equation which takes set point off
> > the
> > + * output dependency in P and D term.
> > + *
> > + *   y[k] = y[k-1] - kp*(x[k] - x[k-1]) + Ki*Ts*e[k] - Kd*(x[k]
> > + *          - 2*x[k-1]+x[k-2])/Ts
> > + *
> > + *
> > +
> > ***********************************************************************/
> > +struct pid_params p_param; +/* cached data from previous loop */
> > +static double xk_1, xk_2; /* input temperature x[k-#] */
> > +
> > +/*
> > + * TODO: make PID parameters tuned automatically,
> > + * 1. use CPU burn to produce open loop unit step response
> > + * 2. calculate PID based on Ziegler-Nichols rule
> > + *
> > + * add a flag for tuning PID
> > + */
> > +int init_thermal_controller(void)
> > +{
> > +	int ret = 0;
> > +
> > +	/* init pid params */
> > +	p_param.ts = ticktime;
> > +	/* TODO: get it from TUI tuning tab */
> > +	p_param.kp = .36;
> > +	p_param.ki = 5.0;
> > +	p_param.kd = 0.19;
> > +
> > +	p_param.t_target = target_temp_user;
> > +
> > +	return ret;
> > +}
> > +
> > +void controller_reset(void)
> > +{
> > +	/* TODO: relax control data when not over thermal limit */
> > +	syslog(LOG_DEBUG, "TC inactive, relax p-state\n");
> > +	p_param.y_k = 0.0;
> > +	xk_1 = 0.0;
> > +	xk_2 = 0.0;
> > +	set_ctrl_state(0);
> > +}
> > +
> > +/* To be called at time interval Ts. Type C PID controller.
> > + *    y[k] = y[k-1] - kp*(x[k] - x[k-1]) + Ki*Ts*e[k] - Kd*(x[k]
> > + *          - 2*x[k-1]+x[k-2])/Ts
> > + * TODO: add low pass filter for D term
> > + */
> > +#define GUARD_BAND (2)
> > +void controller_handler(const double xk, double *yk)
> > +{
> > +	double ek;
> > +	double p_term, i_term, d_term;
> > +
> > +	ek = p_param.t_target - xk; /* error */
> > +	if (ek >= 3.0) {
> > +		syslog(LOG_DEBUG, "PID: %3.1f Below set point
> > %3.1f, stop\n",
> > +			xk, p_param.t_target);
> > +		controller_reset();
> > +		*yk = 0.0;
> > +		return;
> > +	}
> > +	/* compute intermediate PID terms */
> > +	p_term = -p_param.kp * (xk - xk_1);
> > +	i_term = p_param.kp * p_param.ki * p_param.ts * ek;
> > +	d_term = -p_param.kp * p_param.kd * (xk - 2 * xk_1 +
> > xk_2) / p_param.ts;
> > +	/* compute output */
> > +	*yk += p_term + i_term + d_term;
> > +	/* update sample data */
> > +	xk_1 = xk;
> > +	xk_2 = xk_1;
> > +
> > +	/* clamp output adjustment range */
> > +	if (*yk < -LIMIT_HIGH)
> > +		*yk = -LIMIT_HIGH;
> > +	else if (*yk > -LIMIT_LOW)
> > +		*yk = -LIMIT_LOW;
> > +
> > +	p_param.y_k = *yk;
> > +
> > +	set_ctrl_state(lround(fabs(p_param.y_k)));
> > +
> > +}
> > diff --git a/tools/thermal/tmon/sysfs.c b/tools/thermal/tmon/sysfs.c
> > new file mode 100644
> > index 0000000..54e24b3
> > --- /dev/null
> > +++ b/tools/thermal/tmon/sysfs.c
> > @@ -0,0 +1,585 @@
> > +/*
> > + * sysfs.c sysfs ABI access functions for TMON program
> > + *
> > + * Copyright (C) 2013 Intel Corporation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > version
> > + * 2 or later as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * Author: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > + *
> > + */
> > +#include <unistd.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <stdint.h>
> > +#include <dirent.h>
> > +#include <libintl.h>
> > +#include <ctype.h>
> > +#include <time.h>
> > +#include <syslog.h>
> > +#include <sys/time.h>
> > +#include <errno.h>
> > +
> > +#include "tmon.h"
> > +
> > +struct tmon_platform_data ptdata;
> > +const char *trip_type_name[] = {
> > +	"critical",
> > +	"hot",
> > +	"passive",
> > +	"active",
> > +};
> > +
> > +int sysfs_set_ulong(char *path, char *filename, unsigned long val)
> > +{
> > +	FILE *fd;
> > +	int ret = -1;
> > +	char filepath[256];
> > +
> > +	snprintf(filepath, 256, "%s/%s", path, filename);
> > +
> > +	fd = fopen(filepath, "w");
> > +	if (!fd) {
> > +		syslog(LOG_ERR, "Err: open %s: %s\n", __func__,
> > filepath);
> > +		return ret;
> > +	}
> > +	ret = fprintf(fd, "%lu", val);
> > +	fclose(fd);
> > +
> > +	return 0;
> > +}
> > +
> > +/* history of thermal data, used for control algo */
> > +#define NR_THERMAL_RECORDS 3
> > +struct thermal_data_record trec[NR_THERMAL_RECORDS];
> > +int cur_thermal_record; /* index to the trec array */
> > +
> > +static int sysfs_get_ulong(char *path, char *filename, unsigned
> > long *p_ulong) +{
> > +	FILE *fd;
> > +	int ret = -1;
> > +	char filepath[256];
> > +
> > +	snprintf(filepath, 256, "%s/%s", path, filename);
> > +
> > +	fd = fopen(filepath, "r");
> > +	if (!fd) {
> > +		syslog(LOG_ERR, "Err: open %s: %s\n", __func__,
> > filepath);
> > +		return ret;
> > +	}
> > +	ret = fscanf(fd, "%lu", p_ulong);
> > +	fclose(fd);
> > +
> > +	return 0;
> > +}
> > +
> > +static int sysfs_get_string(char *path, char *filename, char *str)
> > +{
> > +	FILE *fd;
> > +	int ret = -1;
> > +	char filepath[256];
> > +
> > +	snprintf(filepath, 256, "%s/%s", path, filename);
> > +
> > +	fd = fopen(filepath, "r");
> > +	if (!fd) {
> > +		syslog(LOG_ERR, "Err: open %s: %s\n", __func__,
> > filepath);
> > +		return ret;
> > +	}
> > +	ret = fscanf(fd, "%256s", str);
> > +	fclose(fd);
> > +
> > +	return ret;
> > +}
> > +
> > +/* get states of the cooling device instance */
> > +static int probe_cdev(struct cdev_info *cdi, char *path)
> > +{
> > +	sysfs_get_string(path, "type", cdi->type);
> > +	sysfs_get_ulong(path, "max_state",  &cdi->max_state);
> > +	sysfs_get_ulong(path, "cur_state", &cdi->cur_state);
> > +
> > +	syslog(LOG_INFO, "%s: %s: type %s, max %lu, curr %lu inst
> > %d\n",
> > +		__func__, path,
> > +		cdi->type, cdi->max_state, cdi->cur_state,
> > cdi->instance); +
> > +	return 0;
> > +}
> > +
> > +static int str_to_trip_type(char *name)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < NR_THERMAL_TRIP_TYPE; i++) {
> > +		if (!strcmp(name, trip_type_name[i]))
> > +			return i;
> > +	}
> > +
> > +	return -ENOENT;
> > +}
> > +
> > +/* scan and fill in trip point info for a thermal zone and trip
> > point id */ +static int get_trip_point_data(char *tz_path, int
> > tzid, int tpid) +{
> > +	char filename[256];
> > +	char temp_str[256];
> > +	int trip_type;
> > +
> > +	if (tpid >= MAX_NR_TRIP)
> > +		return -EINVAL;
> > +	/* check trip point type */
> > +	snprintf(filename, sizeof(filename), "trip_point_%d_type",
> > tpid);
> > +	sysfs_get_string(tz_path, filename, temp_str);
> > +	trip_type = str_to_trip_type(temp_str);
> > +	if (trip_type < 0) {
> > +		syslog(LOG_ERR, "%s:%s no matching type\n",
> > __func__, temp_str);
> > +		return -ENOENT;
> > +	}
> > +	ptdata.tzi[tzid].tp[tpid].type = trip_type;
> > +	syslog(LOG_INFO, "%s:tz:%d tp:%d:type:%s type id %d\n",
> > __func__, tzid,
> > +		tpid, temp_str, trip_type);
> > +
> > +	/* TODO: check attribute */
> > +
> > +	return 0;
> > +}
> > +
> > +/* return instance id for file format such as trip_point_4_temp */
> > +static int get_instance_id(char *name, int pos, int skip)
> > +{
> > +	char *ch;
> > +	int i = 0;
> > +
> > +	ch = strtok(name, "_");
> > +	while (ch != NULL) {
> > +		++i;
> > +		syslog(LOG_INFO, "%s:%s:%s:%d", __func__, name,
> > ch, i);
> > +		ch = strtok(NULL, "_");
> > +		if (pos == i)
> > +			return atol(ch + skip);
> > +	}
> > +
> > +	return -1;
> > +}
> > +
> > +/* Find trip point info of a thermal zone */
> > +static int find_tzone_tp(char *tz_name, char *d_name, struct
> > tz_info *tzi,
> > +			int tz_id)
> > +{
> > +	int tp_id;
> > +	unsigned long temp_ulong;
> > +
> > +	if (strstr(d_name, "trip_point") &&
> > +		strstr(d_name, "temp")) {
> > +		/* check if trip point temp is non-zero
> > +		 * ignore 0/invalid trip points
> > +		 */
> > +		sysfs_get_ulong(tz_name, d_name, &temp_ulong);
> > +		if (temp_ulong < MAX_TEMP_KC) {
> > +			tzi->nr_trip_pts++;
> > +			/* found a valid trip point */
> > +			tp_id = get_instance_id(d_name, 2, 0);
> > +			syslog(LOG_DEBUG, "tzone %s trip %d temp
> > %lu tpnode %s",
> > +				tz_name, tp_id, temp_ulong,
> > d_name);
> > +			if (tp_id < 0 || tp_id >= MAX_NR_TRIP) {
> > +				syslog(LOG_ERR, "Failed to find TP
> > inst %s\n",
> > +					d_name);
> > +				return -1;
> > +			}
> > +			get_trip_point_data(tz_name, tz_id, tp_id);
> > +			tzi->tp[tp_id].temp = temp_ulong;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/* check cooling devices for binding info. */
> > +static int find_tzone_cdev(struct dirent *nl, char *tz_name,
> > +			struct tz_info *tzi, int tz_id, int cid)
> > +{
> > +	unsigned long trip_instance = 0;
> > +	char cdev_name_linked[256];
> > +	char cdev_name[256];
> > +	char cdev_trip_name[256];
> > +	int cdev_id;
> > +
> > +	if (nl->d_type == DT_LNK) {
> > +		syslog(LOG_DEBUG, "TZ%d: cdev: %s cid %d\n",
> > tz_id, nl->d_name,
> > +			cid);
> > +		tzi->nr_cdev++;
> > +		if (tzi->nr_cdev > ptdata.nr_cooling_dev) {
> > +			syslog(LOG_ERR, "Err: Too many cdev? %d\n",
> > +				tzi->nr_cdev);
> > +			return -EINVAL;
> > +		}
> > +		/* find the link to real cooling device record
> > binding */
> > +		snprintf(cdev_name, 256, "%s/%s", tz_name,
> > nl->d_name);
> > +		memset(cdev_name_linked, 0,
> > sizeof(cdev_name_linked));
> > +		if (readlink(cdev_name, cdev_name_linked,
> > +				sizeof(cdev_name_linked) - 1) !=
> > -1) {
> > +			cdev_id =
> > get_instance_id(cdev_name_linked, 1,
> > +						sizeof("device") -
> > 1);
> > +			syslog(LOG_DEBUG, "cdev %s linked to %s :
> > %d\n",
> > +				cdev_name, cdev_name_linked,
> > cdev_id);
> > +			tzi->cdev_binding |= (1 << cdev_id);
> > +
> > +			/* find the trip point in which the cdev
> > is binded to
> > +			 * in this tzone
> > +			 */
> > +			snprintf(cdev_trip_name, 256, "%s%s",
> > nl->d_name,
> > +				"_trip_point");
> > +			sysfs_get_ulong(tz_name, cdev_trip_name,
> > +					&trip_instance);
> > +			/* validate trip point range, e.g. trip
> > could return -1
> > +			 * when passive is enabled
> > +			 */
> > +			if (trip_instance > MAX_NR_TRIP)
> > +				trip_instance = 0;
> > +			tzi->trip_binding[cdev_id] |= 1 <<
> > trip_instance;
> > +			syslog(LOG_DEBUG, "cdev %s -> trip:%lu:
> > 0x%lx %d\n",
> > +				cdev_name, trip_instance,
> > +				tzi->trip_binding[cdev_id],
> > +				cdev_id);
> > +
> > +
> > +		}
> > +		return 0;
> > +	}
> > +
> > +	return -ENODEV;
> > +}
> > +
> > +
> > +
> > +/*****************************************************************************
> > + * Before calling scan_tzones, thermal sysfs must be probed to
> > determine
> > + * the number of thermal zones and cooling devices.
> > + * We loop through each thermal zone and fill in tz_info struct,
> > i.e.
> > + * ptdata.tzi[]
> > +root@jacob-chiefriver:~# tree -d /sys/class/thermal/thermal_zone0
> > +/sys/class/thermal/thermal_zone0
> > +|-- cdev0 -> ../cooling_device4
> > +|-- cdev1 -> ../cooling_device3
> > +|-- cdev10 -> ../cooling_device7
> > +|-- cdev11 -> ../cooling_device6
> > +|-- cdev12 -> ../cooling_device5
> > +|-- cdev2 -> ../cooling_device2
> > +|-- cdev3 -> ../cooling_device1
> > +|-- cdev4 -> ../cooling_device0
> > +|-- cdev5 -> ../cooling_device12
> > +|-- cdev6 -> ../cooling_device11
> > +|-- cdev7 -> ../cooling_device10
> > +|-- cdev8 -> ../cooling_device9
> > +|-- cdev9 -> ../cooling_device8
> > +|-- device -> ../../../LNXSYSTM:00/device:62/LNXTHERM:00
> > +|-- power
> > +`-- subsystem -> ../../../../class/thermal
> > +*****************************************************************************/
> > +static int scan_tzones(void)
> > +{
> > +	DIR *dir;
> > +	struct dirent **namelist;
> > +	char tz_name[256];
> > +	int i, j, n, k = 0;
> > +
> > +	if (!ptdata.nr_tz_sensor) {
> > +		syslog(LOG_ERR, "No thermal zones found!\n");
> > +		return -1;
> > +	}
> > +
> > +	for (i = 0; i <= ptdata.max_tz_instance; i++) {
> > +		memset(tz_name, 0, sizeof(tz_name));
> > +		snprintf(tz_name, 256, "%s/%s%d", THERMAL_SYSFS,
> > TZONE, i); +
> > +		dir = opendir(tz_name);
> > +		if (!dir) {
> > +			syslog(LOG_INFO, "Thermal zone %s
> > skipped\n", tz_name);
> > +			continue;
> > +		}
> > +		/* keep track of valid tzones */
> > +		n = scandir(tz_name, &namelist, 0, alphasort);
> > +		if (n < 0)
> > +			syslog(LOG_ERR, "scandir failed in %s",
> > tz_name);
> > +		else {
> > +			sysfs_get_string(tz_name, "type",
> > ptdata.tzi[k].type);
> > +			ptdata.tzi[k].instance = i;
> > +			/* detect trip points and cdev attached to
> > this tzone */
> > +			j = 0; /* index for cdev */
> > +			ptdata.tzi[k].nr_cdev = 0;
> > +			ptdata.tzi[k].nr_trip_pts = 0;
> > +			while (n--) {
> > +				char *temp_str;
> > +
> > +				if (find_tzone_tp(tz_name,
> > namelist[n]->d_name,
> > +
> > &ptdata.tzi[k], k))
> > +					break;
> > +				temp_str =
> > strstr(namelist[n]->d_name, "cdev");
> > +				if (!temp_str) {
> > +					free(namelist[n]);
> > +					continue;
> > +				}
> > +				if (!find_tzone_cdev(namelist[n],
> > tz_name,
> > +
> > &ptdata.tzi[k], i, j))
> > +					j++; /* increment cdev
> > index */
> > +				free(namelist[n]);
> > +			}
> > +			free(namelist);
> > +		}
> > +		/*TODO: reverse trip points */
> > +		closedir(dir);
> > +		syslog(LOG_INFO, "TZ %d has %d cdev\n",	i,
> > +			ptdata.tzi[k].nr_cdev);
> > +		k++;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int scan_cdevs(void)
> > +{
> > +	DIR *dir;
> > +	struct dirent **namelist;
> > +	char cdev_name[256];
> > +	int i, n, k = 0;
> > +
> > +	for (i = 0; i <= ptdata.max_cdev_instance; i++) {
> > +		memset(cdev_name, 0, sizeof(cdev_name));
> > +		snprintf(cdev_name, 256, "%s/%s%d", THERMAL_SYSFS,
> > CDEV, i); +
> > +		dir = opendir(cdev_name);
> > +		if (!dir) {
> > +			syslog(LOG_INFO, "Cooling dev %s
> > skipped\n", cdev_name);
> > +			/* there is a gap in cooling device id,
> > check again
> > +			 * for the same index.
> > +			 */
> > +			continue;
> > +		}
> > +
> > +		n = scandir(cdev_name, &namelist, 0, alphasort);
> > +		if (n < 0)
> > +			syslog(LOG_ERR, "scandir failed in %s",
> > cdev_name);
> > +		else {
> > +			sysfs_get_string(cdev_name, "type",
> > ptdata.cdi[k].type);
> > +			ptdata.cdi[k].instance = i;
> > +			if (strstr(ptdata.cdi[k].type, ctrl_cdev))
> > {
> > +				ptdata.cdi[k].flag |=
> > CDEV_FLAG_IN_CONTROL;
> > +				syslog(LOG_DEBUG, "control cdev id
> > %d\n", i);
> > +			}
> > +			while (n--)
> > +				free(namelist[n]);
> > +			free(namelist);
> > +		}
> > +		closedir(dir);
> > +		k++;
> > +	}
> > +	return 0;
> > +}
> > +
> > +
> > +int probe_thermal_sysfs(void)
> > +{
> > +	DIR *dir;
> > +	struct dirent **namelist;
> > +	int n;
> > +
> > +	dir = opendir(THERMAL_SYSFS);
> > +	if (!dir) {
> > +		syslog(LOG_ERR, "No thermal sysfs\n");
> > +		return -1;
> > +	}
> > +	n = scandir(THERMAL_SYSFS, &namelist, 0, alphasort);
> > +	if (n < 0)
> > +		syslog(LOG_ERR, "scandir failed in thermal sysfs");
> > +	else {
> > +		/* detect number of thermal zones and cooling
> > devices */
> > +		while (n--) {
> > +			int inst;
> > +
> > +			if (strstr(namelist[n]->d_name, CDEV)) {
> > +				inst =
> > get_instance_id(namelist[n]->d_name, 1,
> > +						sizeof("device") -
> > 1);
> > +				/* keep track of the max cooling
> > device since
> > +				 * there may be gaps.
> > +				 */
> > +				if (inst >
> > ptdata.max_cdev_instance)
> > +					ptdata.max_cdev_instance =
> > inst; +
> > +				syslog(LOG_DEBUG, "found cdev: %s
> > %d %d\n",
> > +					namelist[n]->d_name,
> > +					ptdata.nr_cooling_dev,
> > +					ptdata.max_cdev_instance);
> > +				ptdata.nr_cooling_dev++;
> > +			} else if (strstr(namelist[n]->d_name,
> > TZONE)) {
> > +				inst =
> > get_instance_id(namelist[n]->d_name, 1,
> > +						sizeof("zone") -
> > 1);
> > +				if (inst > ptdata.max_tz_instance)
> > +					ptdata.max_tz_instance =
> > inst; +
> > +				syslog(LOG_DEBUG, "found tzone: %s
> > %d %d\n",
> > +					namelist[n]->d_name,
> > +					ptdata.nr_tz_sensor,
> > +					ptdata.max_tz_instance);
> > +				ptdata.nr_tz_sensor++;
> > +			}
> > +			free(namelist[n]);
> > +		}
> > +		free(namelist);
> > +	}
> > +	syslog(LOG_INFO, "found %d tzone(s), %d cdev(s), target
> > zone %d\n",
> > +		ptdata.nr_tz_sensor, ptdata.nr_cooling_dev,
> > +		target_thermal_zone);
> > +	closedir(dir);
> > +
> > +	ptdata.tzi = calloc(sizeof(struct tz_info),
> > ptdata.nr_tz_sensor+1);
> > +	if (!ptdata.tzi) {
> > +		syslog(LOG_ERR, "Err: allocate tz_info\n");
> > +		return -1;
> > +	}
> > +
> > +	ptdata.cdi = calloc(sizeof(struct cdev_info),
> > ptdata.nr_cooling_dev+1);
> > +	if (!ptdata.cdi) {
> > +		syslog(LOG_ERR, "Err: allocate cdev_info\n");
> > +		return -1;
> > +	}
> > +
> > +	/* now probe tzones */
> > +	if (scan_tzones())
> > +		return -1;
> > +	if (scan_cdevs())
> > +		return -1;
> > +	return 0;
> > +}
> > +
> > +/* convert sysfs zone instance to zone array index */
> > +int zone_instance_to_index(int zone_inst)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < ptdata.nr_tz_sensor; i++)
> > +		if (ptdata.tzi[i].instance == zone_inst)
> > +			return i;
> > +	return -ENOENT;
> > +}
> > +
> > +/* read temperature of all thermal zones */
> > +int update_thermal_data()
> > +{
> > +	int i;
> > +	char tz_name[256];
> > +	static unsigned long samples;
> > +
> > +	if (!ptdata.nr_tz_sensor) {
> > +		syslog(LOG_ERR, "No thermal zones found!\n");
> > +		return -1;
> > +	}
> > +
> > +	/* circular buffer for keeping historic data */
> > +	if (cur_thermal_record >= NR_THERMAL_RECORDS)
> > +		cur_thermal_record = 0;
> > +	gettimeofday(&trec[cur_thermal_record].tv, NULL);
> > +	if (tmon_log) {
> > +		fprintf(tmon_log, "%lu ", ++samples);
> > +		fprintf(tmon_log, "%3.1f ", p_param.t_target);
> > +	}
> > +	for (i = 0; i < ptdata.nr_tz_sensor; i++) {
> > +		memset(tz_name, 0, sizeof(tz_name));
> > +		snprintf(tz_name, 256, "%s/%s%d", THERMAL_SYSFS,
> > TZONE,
> > +			ptdata.tzi[i].instance);
> > +		sysfs_get_ulong(tz_name, "temp",
> > +				&trec[cur_thermal_record].temp[i]);
> > +		if (tmon_log)
> > +			fprintf(tmon_log, "%lu ",
> > +
> > trec[cur_thermal_record].temp[i]/1000);
> > +	}
> > +	for (i = 0; i < ptdata.nr_cooling_dev; i++) {
> > +		char cdev_name[256];
> > +		unsigned long val;
> > +
> > +		snprintf(cdev_name, 256, "%s/%s%d", THERMAL_SYSFS,
> > CDEV,
> > +			ptdata.cdi[i].instance);
> > +		probe_cdev(&ptdata.cdi[i], cdev_name);
> > +		val = ptdata.cdi[i].cur_state;
> > +		if (val > 1000000)
> > +			val = 0;
> > +		if (tmon_log)
> > +			fprintf(tmon_log, "%lu ", val);
> > +	}
> > +
> > +	if (tmon_log) {
> > +		fprintf(tmon_log, "\n");
> > +		fflush(tmon_log);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +void set_ctrl_state(unsigned long state)
> > +{
> > +	char ctrl_cdev_path[256];
> > +	int i;
> > +	unsigned long cdev_state;
> > +
> > +	if (no_control)
> > +		return;
> > +	/* set all ctrl cdev to the same state */
> > +	for (i = 0; i < ptdata.nr_cooling_dev; i++) {
> > +		if (ptdata.cdi[i].flag & CDEV_FLAG_IN_CONTROL) {
> > +			if (ptdata.cdi[i].max_state < 10) {
> > +				syslog(LOG_WARNING,
> > +					"not enough states in
> > control cdev\n");
> > +				return;
> > +			}
> > +			/* scale to percentage of max_state */
> > +			cdev_state = state *
> > ptdata.cdi[i].max_state/100;
> > +			syslog(LOG_DEBUG,
> > +				"ctrl cdev %d set state %lu scaled
> > to %lu\n",
> > +				ptdata.cdi[i].instance, state,
> > cdev_state);
> > +			snprintf(ctrl_cdev_path, 256, "%s/%s%d",
> > THERMAL_SYSFS,
> > +				CDEV, ptdata.cdi[i].instance);
> > +			syslog(LOG_DEBUG, "ctrl cdev path %s",
> > ctrl_cdev_path);
> > +			sysfs_set_ulong(ctrl_cdev_path,
> > "cur_state",
> > +					cdev_state);
> > +		}
> > +	}
> > +}
> > +
> > +void get_ctrl_state(unsigned long *state)
> > +{
> > +	char ctrl_cdev_path[256];
> > +	int ctrl_cdev_id = -1;
> > +	int i;
> > +
> > +	/* TODO: take average of all ctrl types. also consider
> > change based on
> > +	 * uevent. Take the first reading for now.
> > +	 */
> > +	for (i = 0; i < ptdata.nr_cooling_dev; i++) {
> > +		if (ptdata.cdi[i].flag & CDEV_FLAG_IN_CONTROL) {
> > +			ctrl_cdev_id = ptdata.cdi[i].instance;
> > +			syslog(LOG_INFO, "ctrl cdev %d get
> > state\n",
> > +				ptdata.cdi[i].instance);
> > +			break;
> > +		}
> > +	}
> > +	if (ctrl_cdev_id == -1) {
> > +		*state = 0;
> > +		return;
> > +	}
> > +	snprintf(ctrl_cdev_path, 256, "%s/%s%d", THERMAL_SYSFS,
> > +		CDEV, ctrl_cdev_id);
> > +	sysfs_get_ulong(ctrl_cdev_path, "cur_state", state);
> > +}
> > +
> > +void free_thermal_data(void)
> > +{
> > +	free(ptdata.tzi);
> > +	free(ptdata.cdi);
> > +}
> > diff --git a/tools/thermal/tmon/tmon.8 b/tools/thermal/tmon/tmon.8
> > new file mode 100644
> > index 0000000..0be727c
> > --- /dev/null
> > +++ b/tools/thermal/tmon/tmon.8
> > @@ -0,0 +1,142 @@
> > +.TH TMON 8
> > +.SH NAME
> > +\fBtmon\fP - A monitoring and testing tool for Linux kernel
> > thermal subsystem +
> > +.SH SYNOPSIS
> > +.ft B
> > +.B tmon
> > +.RB [ Options ]
> > +.br
> > +.SH DESCRIPTION
> > +\fBtmon \fP can be used to visualize thermal relationship and
> > +real-time thermal data; tune
> > +and test cooling devices and sensors; collect thermal data for
> > offline +analysis and plot. \fBtmon\fP must be run as root in order
> > to control device +states via sysfs.
> > +.PP
> > +\fBFunctions\fP
> > +.PP
> > +.nf
> > +1. Thermal relationships:
> > +- show thermal zone information
> > +- show cooling device information
> > +- show trip point binding within each thermal zone
> > +- show trip point and cooling device instance bindings
> > +.PP
> > +2. Real time data display
> > +- show temperature of all thermal zones w.r.t. its trip points and
> > types +- show states of all cooling devices
> > +.PP
> > +3. Thermal relationship learning and device tuning
> > +- with a built-in Proportional Integral Derivative (\fBPID\fP)
> > +controller, user can pair a cooling device to a thermal sensor for
> > +testing the effectiveness and learn about the thermal distance
> > between the two +- allow manual control of cooling device states
> > and target temperature +.PP
> > +4. Data logging in /var/tmp/tmon.log
> > +- contains thermal configuration data, i.e. cooling device, thermal
> > + zones, and trip points. Can be used for data  collection in remote
> > + debugging.
> > +- log real-time thermal data into space separated format that can
> > be
> > + directly consumed by plotting tools such as Rscript.
> > +
> > +.SS Options
> > +.PP
> > +The \fB-c --control\fP option sets a cooling device type to
> > control temperature +of a thermal zone
> > +.PP
> > +The \fB-d --daemon\fP option runs \fBtmon \fP as daemon without
> > user interface +.PP
> > +The \fB-g --debug\fP option allow debug messages to be stored in
> > syslog +.PP
> > +The \fB-h --help\fP option shows help message
> > +.PP
> > +The \fB-l --log\fP option write data to /var/tmp/tmon.log
> > +.PP
> > +The \fB-t --time-interval\fP option sets the polling interval in
> > seconds +.PP
> > +The \fB-v --version\fP option shows the version of \fBtmon \fP
> > +.PP
> > +The \fB-z --zone\fP option sets the target therma zone instance to
> > be controlled +.PP
> > +
> > +.SH FIELD DESCRIPTIONS
> > +.nf
> > +.PP
> > +\fBP \fP passive cooling trip point type
> > +\fBA \fP active cooling trip point type (fan)
> > +\fBC \fP critical trip point type
> > +\fBA \fP hot trip point type
> > +\fBkp \fP proportional gain of \fBPID\fP controller
> > +\fBki \fP integral gain of \fBPID\fP controller
> > +\fBkd \fP derivative gain of \fBPID\fP controller
> > +
> > +.SH REQUIREMENT
> > +Build depends on ncurses
> > +.PP
> > +Runtime depends on window size large enough to show the number of
> > +devices found on the system.
> > +
> > +.PP
> > +
> > +.SH INTERACTIVE COMMANDS
> > +.pp
> > +.nf
> > +\fBCtrl-C, q/Q\fP stops \fBtmon\fP
> > +\fBTAB\fP shows tuning pop up panel, choose a letter to modify
> > +
> > +.SH EXAMPLES
> > +Without any parameters, tmon is in monitoring only mode and refresh
> > +screen every 1 second.
> > +.PP
> > +1. For monitoring only:
> > +.nf
> > +$ sudo ./tmon
> > +
> > +2. Use Processor cooling device to control thermal zone 0 at
> > default 65C. +$ sudo ./tmon -c Processor -z 0
> > +
> > +3. Use intel_powerclamp(idle injection) cooling device to control
> > thermal zone 1 +$ sudo ./tmon -c intel_powerclamp -z 1
> > +
> > +4. Turn on debug and collect data log at /var/tmp/tmon.log
> > +$ sudo ./tmon -g -l
> > +
> > +For example, the log below shows PID controller was adjusting
> > current states +for all cooling devices with "Processor" type such
> > that thermal zone 0 +can stay below 65 dC.
> > +
> > +#---------- THERMAL DATA LOG STARTED -----------
> > +Samples TargetTemp acpitz0    acpitz1    Fan0 Fan1 Fan2 Fan3 Fan4
> > Fan5 +Fan6 Fan7 Fan8 Fan9 Processor10 Processor11 Processor12
> > Processor13 +LCD14 intel_powerclamp15 1 65.0 65 65 0 0 0 0 0 0 0 0
> > 0 0 0 0 0 0 6 0 2 +65.0 66 65 0 0 0 0 0 0 0 0 0 0 4 4 4 4 6 0 3
> > 65.0 60 54 0 0 0 0 0 0 0 0 +0 0 4 4 4 4 6 0 4 65.0 53 53 0 0 0 0 0
> > 0 0 0 0 0 4 4 4 4 6 0 +5 65.0 52 52 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6 0
> > +6 65.0 53 65 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6 0
> > +7 65.0 68 70 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6 0
> > +8 65.0 68 68 0 0 0 0 0 0 0 0 0 0 5 5 5 5 6 0
> > +9 65.0 68 68 0 0 0 0 0 0 0 0 0 0 6 6 6 6 6 0
> > +10 65.0 67 67 0 0 0 0 0 0 0 0 0 0 7 7 7 7 6 0
> > +11 65.0 67 67 0 0 0 0 0 0 0 0 0 0 8 8 8 8 6 0
> > +12 65.0 67 67 0 0 0 0 0 0 0 0 0 0 8 8 8 8 6 0
> > +13 65.0 67 67 0 0 0 0 0 0 0 0 0 0 9 9 9 9 6 0
> > +14 65.0 66 66 0 0 0 0 0 0 0 0 0 0 10 10 10 10 6 0
> > +15 65.0 66 67 0 0 0 0 0 0 0 0 0 0 10 10 10 10 6 0
> > +16 65.0 66 66 0 0 0 0 0 0 0 0 0 0 11 11 11 11 6 0
> > +17 65.0 66 66 0 0 0 0 0 0 0 0 0 0 11 11 11 11 6 0
> > +18 65.0 64 61 0 0 0 0 0 0 0 0 0 0 11 11 11 11 6 0
> > +19 65.0 60 59 0 0 0 0 0 0 0 0 0 0 12 12 12 12 6 0
> > +
> > +Data can be read directly into an array by an example R-script
> > below: +
> > +#!/usr/bin/Rscript
> > +tdata <- read.table("/var/tmp/tmon.log", header=T,
> > comment.char="#") +attach(tdata)
> > +jpeg("tmon.jpg")
> > +X11()
> > +g_range <- range(0, intel_powerclamp15, TargetTemp, acpitz0)
> > +plot( Samples, intel_powerclamp15, col="blue", ylim=g_range,
> > axes=FALSE, ann=FALSE) +par(new=TRUE)
> > +lines(TargetTemp, type="o", pch=22, lty=2, col="red")
> > +dev.off()
> > diff --git a/tools/thermal/tmon/tmon.c b/tools/thermal/tmon/tmon.c
> > new file mode 100644
> > index 0000000..5f13fb1
> > --- /dev/null
> > +++ b/tools/thermal/tmon/tmon.c
> > @@ -0,0 +1,350 @@
> > +/*
> > + * tmon.c Thermal Monitor (TMON) main function and entry point
> > + *
> > + * Copyright (C) 2012 Intel Corporation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > version
> > + * 2 or later as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * Author: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > + *
> > + */
> > +
> > +#include <getopt.h>
> > +#include <unistd.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <ncurses.h>
> > +#include <ctype.h>
> > +#include <time.h>
> > +#include <signal.h>
> > +#include <limits.h>
> > +#include <sys/time.h>
> > +#include <pthread.h>
> > +#include <math.h>
> > +#include <stdarg.h>
> > +#include <syslog.h>
> > +
> > +#include "tmon.h"
> > +
> > +unsigned long ticktime = 1; /* seconds */
> > +unsigned long no_control = 1; /* monitoring only or use cooling
> > device for
> > +			       * temperature control.
> > +			       */
> > +double time_elapsed = 0.0;
> > +unsigned long target_temp_user = 65; /* can be select by tui later
> > */ +int dialogue_on;
> > +int tmon_exit;
> > +static short	daemon_mode;
> > +static int logging; /* for recording thermal data to a file */
> > +static int debug_on;
> > +FILE *tmon_log;
> > +char ctrl_cdev[CDEV_NAME_SIZE]; /*cooling device used for the PID
> > controller */ +int target_thermal_zone; /* user selected target
> > zone instance */ +static void	start_daemon_mode(void);
> > +
> > +pthread_t event_tid;
> > +pthread_mutex_t input_lock;
> > +void usage()
> > +{
> > +	printf("Usage: tmon [OPTION...]\n");
> > +	printf("  -c, --control         cooling device in
> > control\n");
> > +	printf("  -d, --daemon          run as daemon, no TUI\n");
> > +	printf("  -g, --debug           debug message in
> > syslog\n");
> > +	printf("  -h, --help            show this help message\n");
> > +	printf("  -l, --log             log data
> > to /var/tmp/tmon.log\n");
> > +	printf("  -t, --time-interval   sampling time interval, >
> > 1 sec.\n");
> > +	printf("  -v, --version         show version\n");
> > +	printf("  -z, --zone            target thermal zone id\n");
> > +
> > +	exit(0);
> > +}
> > +
> > +void version()
> > +{
> > +	printf("TMON version %s\n", VERSION);
> > +	exit(EXIT_SUCCESS);
> > +}
> > +
> > +static void tmon_cleanup(void)
> > +{
> > +
> > +	syslog(LOG_INFO, "TMON exit cleanup\n");
> > +	fflush(stdout);
> > +	refresh();
> > +	if (tmon_log)
> > +		fclose(tmon_log);
> > +	if (event_tid) {
> > +		pthread_mutex_lock(&input_lock);
> > +		pthread_cancel(event_tid);
> > +		pthread_mutex_unlock(&input_lock);
> > +		pthread_mutex_destroy(&input_lock);
> > +	}
> > +	closelog();
> > +	/* relax control knobs, undo throttling */
> > +	set_ctrl_state(0);
> > +
> > +	keypad(stdscr, FALSE);
> > +	echo();
> > +	nocbreak();
> > +	close_windows();
> > +	endwin();
> > +	free_thermal_data();
> > +
> > +	exit(1);
> > +}
> > +
> > +
> > +static void tmon_sig_handler(int sig)
> > +{
> > +	syslog(LOG_INFO, "TMON caught signal %d\n", sig);
> > +	refresh();
> > +	switch (sig) {
> > +	case SIGTERM:
> > +		printf("sigterm, exit and clean up\n");
> > +		fflush(stdout);
> > +		break;
> > +	case SIGKILL:
> > +		printf("sigkill, exit and clean up\n");
> > +		fflush(stdout);
> > +		break;
> > +	case SIGINT:
> > +		printf("ctrl-c, exit and clean up\n");
> > +		fflush(stdout);
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +	tmon_exit = true;
> > +}
> > +
> > +
> > +static void start_syslog(void)
> > +{
> > +	if (debug_on)
> > +		setlogmask(LOG_UPTO(LOG_DEBUG));
> > +	else
> > +		setlogmask(LOG_UPTO(LOG_ERR));
> > +	openlog("tmon.log", LOG_CONS | LOG_PID | LOG_NDELAY,
> > LOG_LOCAL0);
> > +	syslog(LOG_NOTICE, "TMON started by User %d", getuid());
> > +}
> > +
> > +static void prepare_logging(void)
> > +{
> > +	int i;
> > +
> > +	if (!logging)
> > +		return;
> > +	/* open local data log file */
> > +	tmon_log = fopen(TMON_LOG_FILE, "w+");
> > +	if (!tmon_log) {
> > +		syslog(LOG_ERR, "failed to open log file %s\n",
> > TMON_LOG_FILE);
> > +		return;
> > +	}
> > +
> > +	fprintf(tmon_log, "#----------- THERMAL SYSTEM CONFIG
> > -------------\n");
> > +	for (i = 0; i < ptdata.nr_tz_sensor; i++) {
> > +		char binding_str[33]; /* size of long + 1 */
> > +		int j;
> > +
> > +		memset(binding_str, 0, sizeof(binding_str));
> > +		for (j = 0; j < 32; j++)
> > +			binding_str[j] =
> > (ptdata.tzi[i].cdev_binding & 1<<j) ?
> > +				'1' : '0';
> > +
> > +		fprintf(tmon_log, "#thermal zone %s%02d cdevs
> > binding: %32s\n",
> > +			ptdata.tzi[i].type,
> > +			ptdata.tzi[i].instance,
> > +			binding_str);
> > +		for (j = 0; j <	ptdata.tzi[i].nr_trip_pts;
> > j++) {
> > +			fprintf(tmon_log, "#\tTP%02d type:%s,
> > temp:%lu\n", j,
> > +
> > trip_type_name[ptdata.tzi[i].tp[j].type],
> > +				ptdata.tzi[i].tp[j].temp);
> > +		}
> > +
> > +	}
> > +
> > +	for (i = 0; i <	ptdata.nr_cooling_dev; i++)
> > +		fprintf(tmon_log, "#cooling devices%02d: %s\n",
> > +			i, ptdata.cdi[i].type);
> > +
> > +	fprintf(tmon_log, "#---------- THERMAL DATA LOG STARTED
> > -----------\n");
> > +	fprintf(tmon_log, "Samples TargetTemp ");
> > +	for (i = 0; i < ptdata.nr_tz_sensor; i++) {
> > +		fprintf(tmon_log, "%s%d    ", ptdata.tzi[i].type,
> > +			ptdata.tzi[i].instance);
> > +	}
> > +	for (i = 0; i <	ptdata.nr_cooling_dev; i++)
> > +		fprintf(tmon_log, "%s%d ", ptdata.cdi[i].type,
> > +			ptdata.cdi[i].instance);
> > +
> > +	fprintf(tmon_log, "\n");
> > +}
> > +
> > +static struct option opts[] = {
> > +	{ "control", 1, NULL, 'c' },
> > +	{ "daemon", 0, NULL, 'd' },
> > +	{ "time-interval", 1, NULL, 't' },
> > +	{ "log", 0, NULL, 'l' },
> > +	{ "help", 0, NULL, 'h' },
> > +	{ "version", 0, NULL, 'v' },
> > +	{ "debug", 0, NULL, 'g' },
> > +	{ 0, 0, NULL, 0 }
> > +};
> > +
> > +
> > +int main(int argc, char **argv)
> > +{
> > +	int err = 0;
> > +	int id2 = 0, c;
> > +	double yk = 0.0; /* controller output */
> > +	int target_tz_index;
> > +
> > +	if (geteuid() != 0) {
> > +		printf("TMON needs to be run as root\n");
> > +		exit(EXIT_FAILURE);
> > +	}
> > +
> > +	while ((c = getopt_long(argc, argv, "c:dlht:vgz:", opts,
> > &id2)) != -1) {
> > +		switch (c) {
> > +		case 'c':
> > +			no_control = 0;
> > +			strncpy(ctrl_cdev, optarg, CDEV_NAME_SIZE);
> > +			break;
> > +		case 'd':
> > +			start_daemon_mode();
> > +			printf("Run TMON in daemon mode\n");
> > +			break;
> > +		case 't':
> > +			ticktime = strtod(optarg, NULL);
> > +			if (ticktime < 1)
> > +				ticktime = 1;
> > +			break;
> > +		case 'l':
> > +			printf("Logging data
> > to /var/tmp/tmon.log\n");
> > +			logging = 1;
> > +			break;
> > +		case 'h':
> > +			usage();
> > +			break;
> > +		case 'v':
> > +			version();
> > +			break;
> > +		case 'g':
> > +			debug_on = 1;
> > +			break;
> > +		case 'z':
> > +			target_thermal_zone = strtod(optarg, NULL);
> > +			break;
> > +		default:
> > +			break;
> > +		}
> > +	}
> > +	if (pthread_mutex_init(&input_lock, NULL) != 0) {
> > +		printf("\n mutex init failed\n");
> > +		return 1;
> > +	}
> > +	start_syslog();
> > +	if (signal(SIGINT, tmon_sig_handler) == SIG_ERR)
> > +		syslog(LOG_DEBUG, "Cannot handle SIGINT\n");
> > +	if (signal(SIGTERM, tmon_sig_handler) == SIG_ERR)
> > +		syslog(LOG_DEBUG, "Cannot handle SIGINT\n");
> > +
> > +	if (probe_thermal_sysfs()) {
> > +		closelog();
> > +		return -1;
> > +	}
> > +	initialize_curses();
> > +	setup_windows();
> > +	signal(SIGWINCH, resize_handler);
> > +	show_title_bar();
> > +	show_sensors_w();
> > +	show_cooling_device();
> > +	update_thermal_data();
> > +	show_data_w();
> > +	prepare_logging();
> > +	init_thermal_controller();
> > +
> > +	nodelay(stdscr, TRUE);
> > +	err = pthread_create(&event_tid, NULL, &handle_tui_events,
> > NULL);
> > +	if (err != 0) {
> > +		printf("\ncan't create thread :[%s]",
> > strerror(err));
> > +		tmon_cleanup();
> > +		exit(EXIT_FAILURE);
> > +	}
> > +
> > +	/* validate range of user selected target zone, default to
> > the first
> > +	 * instance if out of range
> > +	 */
> > +	target_tz_index =
> > zone_instance_to_index(target_thermal_zone);
> > +	if (target_tz_index < 0) {
> > +		target_thermal_zone = ptdata.tzi[0].instance;
> > +		syslog(LOG_ERR, "target zone is not found, default
> > to %d\n",
> > +			target_thermal_zone);
> > +	}
> > +	while (1) {
> > +		sleep(ticktime);
> > +		show_title_bar();
> > +		show_sensors_w();
> > +		update_thermal_data();
> > +		if (!dialogue_on) {
> > +			show_data_w();
> > +			show_cooling_device();
> > +		}
> > +		cur_thermal_record++;
> > +		time_elapsed += ticktime;
> > +		controller_handler(trec[0].temp[target_tz_index] /
> > 1000,
> > +				&yk);
> > +		trec[0].pid_out_pct = yk;
> > +		if (!dialogue_on)
> > +			show_control_w();
> > +		if (tmon_exit)
> > +			break;
> > +	}
> > +	tmon_cleanup();
> > +	return 0;
> > +}
> > +
> > +static void start_daemon_mode()
> > +{
> > +	daemon_mode = 1;
> > +	/* fork */
> > +	pid_t	sid, pid = fork();
> > +	if (pid < 0) {
> > +		exit(EXIT_FAILURE);
> > +	} else if (pid > 0)
> > +		/* kill parent */
> > +		exit(EXIT_SUCCESS);
> > +
> > +	/* disable TUI, it may not be necessary, but saves some
> > resource */
> > +	disable_tui();
> > +
> > +	/* change the file mode mask */
> > +	umask(0);
> > +
> > +	/* new SID for the daemon process */
> > +	sid = setsid();
> > +	if (sid < 0)
> > +		exit(EXIT_FAILURE);
> > +
> > +	/* change working directory */
> > +	if ((chdir("/")) < 0)
> > +		exit(EXIT_FAILURE);
> > +
> > +
> > +	sleep(10);
> > +
> > +	close(STDIN_FILENO);
> > +	close(STDOUT_FILENO);
> > +	close(STDERR_FILENO);
> > +
> > +}
> > diff --git a/tools/thermal/tmon/tmon.h b/tools/thermal/tmon/tmon.h
> > new file mode 100644
> > index 0000000..9e3c49c
> > --- /dev/null
> > +++ b/tools/thermal/tmon/tmon.h
> > @@ -0,0 +1,204 @@
> > +/*
> > + * tmon.h contains data structures and constants used by TMON
> > + *
> > + * Copyright (C) 2012 Intel Corporation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > version
> > + * 2 or later as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * Author Name Jacob Pan <jacob.jun.pan@linux.intel.com>
> > + *
> > + */
> > +
> > +#ifndef TMON_H
> > +#define TMON_H
> > +
> > +#define MAX_DISP_TEMP 125
> > +#define MAX_CTRL_TEMP 105
> > +#define MIN_CTRL_TEMP 40
> > +#define MAX_NR_TZONE 16
> > +#define MAX_NR_CDEV 32
> > +#define MAX_NR_TRIP 16
> > +#define MAX_NR_CDEV_TRIP 12 /* number of cooling devices that can
> > bind
> > +			     * to a thermal zone trip.
> > +			     */
> > +#define MAX_TEMP_KC 140000
> > +/* starting char position to draw sensor data, such as tz names
> > + * trip point list, etc.
> > + */
> > +#define DATA_LEFT_ALIGN 10
> > +#define NR_LINES_TZDATA 1
> > +#define TMON_LOG_FILE "/var/tmp/tmon.log"
> > +
> > +extern unsigned long ticktime;
> > +extern double time_elapsed;
> > +extern unsigned long target_temp_user;
> > +extern int dialogue_on;
> > +extern char ctrl_cdev[];
> > +extern pthread_mutex_t input_lock;
> > +extern int tmon_exit;
> > +extern int target_thermal_zone;
> > +/* use fixed size record to simplify data processing and transfer
> > + * TBD: more info to be added, e.g. programmable trip point data.
> > +*/
> > +struct thermal_data_record {
> > +	struct timeval tv;
> > +	unsigned long temp[MAX_NR_TZONE];
> > +	double pid_out_pct;
> > +};
> > +
> > +struct cdev_info {
> > +	char type[64];
> > +	int instance;
> > +	unsigned long max_state;
> > +	unsigned long cur_state;
> > +	unsigned long flag;
> > +};
> > +
> > +enum trip_type {
> > +	THERMAL_TRIP_CRITICAL,
> > +	THERMAL_TRIP_HOT,
> > +	THERMAL_TRIP_PASSIVE,
> > +	THERMAL_TRIP_ACTIVE,
> > +	NR_THERMAL_TRIP_TYPE,
> > +};
> > +
> > +struct trip_point {
> > +	enum trip_type type;
> > +	unsigned long temp;
> > +	unsigned long hysteresis;
> > +	int attribute; /* programmability etc. */
> > +};
> > +
> > +/* thermal zone configuration information, binding with cooling
> > devices could
> > + * change at runtime.
> > + */
> > +struct tz_info {
> > +	char type[256]; /* e.g. acpitz */
> > +	int instance;
> > +	int passive; /* active zone has passive node to force
> > passive mode */
> > +	int nr_cdev; /* number of cooling device binded */
> > +	int nr_trip_pts;
> > +	struct trip_point tp[MAX_NR_TRIP];
> > +	unsigned long cdev_binding; /* bitmap for attached cdevs */
> > +	/* cdev bind trip points, allow one cdev bind to multiple
> > trips */
> > +	unsigned long trip_binding[MAX_NR_CDEV];
> > +};
> > +
> > +struct tmon_platform_data {
> > +	int nr_tz_sensor;
> > +	int nr_cooling_dev;
> > +	/* keep track of instance ids since there might be gaps */
> > +	int max_tz_instance;
> > +	int max_cdev_instance;
> > +	struct tz_info *tzi;
> > +	struct cdev_info *cdi;
> > +};
> > +
> > +struct control_ops {
> > +	void (*set_ratio)(unsigned long ratio);
> > +	unsigned long (*get_ratio)(unsigned long ratio);
> > +
> > +};
> > +
> > +enum cdev_types {
> > +	CDEV_TYPE_PROC,
> > +	CDEV_TYPE_FAN,
> > +	CDEV_TYPE_MEM,
> > +	CDEV_TYPE_NR,
> > +};
> > +
> > +/* REVISIT: the idea is to group sensors if possible, e.g. on
> > intel mid
> > + * we have "skin0", "skin1", "sys", "msicdie"
> > + * on DPTF enabled systems, we might have PCH, TSKN, TAMB, etc.
> > + */
> > +enum tzone_types {
> > +	TZONE_TYPE_ACPI,
> > +	TZONE_TYPE_PCH,
> > +	TZONE_TYPE_NR,
> > +};
> > +
> > +/* limit the output of PID controller adjustment */
> > +#define LIMIT_HIGH (95)
> > +#define LIMIT_LOW  (2)
> > +
> > +struct pid_params {
> > +	double kp;  /* Controller gain from Dialog Box */
> > +	double ki;  /* Time-constant for I action from Dialog Box
> > */
> > +	double kd;  /* Time-constant for D action from Dialog Box
> > */
> > +	double ts;
> > +	double k_lpf;
> > +
> > +	double t_target;
> > +	double y_k;
> > +};
> > +
> > +extern int init_thermal_controller(void);
> > +extern void controller_handler(const double xk, double *yk);
> > +
> > +extern struct tmon_platform_data ptdata;
> > +extern struct pid_params p_param;
> > +
> > +extern FILE *tmon_log;
> > +extern int cur_thermal_record; /* index to the trec array */
> > +extern struct thermal_data_record trec[];
> > +extern const char *trip_type_name[];
> > +extern unsigned long no_control;
> > +
> > +extern void initialize_curses(void);
> > +extern void show_controller_stats(char *line);
> > +extern void show_title_bar(void);
> > +extern void setup_windows(void);
> > +extern void disable_tui(void);
> > +extern void show_sensors_w(void);
> > +extern void show_data_w(void);
> > +extern void write_status_bar(int x, char *line);
> > +extern void show_control_w();
> > +
> > +extern void show_cooling_device(void);
> > +extern void show_dialogue(void);
> > +extern int update_thermal_data(void);
> > +
> > +extern int probe_thermal_sysfs(void);
> > +extern void free_thermal_data(void);
> > +extern	void resize_handler(int sig);
> > +extern void set_ctrl_state(unsigned long state);
> > +extern void get_ctrl_state(unsigned long *state);
> > +extern void *handle_tui_events(void *arg);
> > +extern int sysfs_set_ulong(char *path, char *filename, unsigned
> > long val); +extern int zone_instance_to_index(int zone_inst);
> > +extern void close_windows(void);
> > +
> > +#define PT_COLOR_DEFAULT    1
> > +#define PT_COLOR_HEADER_BAR 2
> > +#define PT_COLOR_ERROR      3
> > +#define PT_COLOR_RED        4
> > +#define PT_COLOR_YELLOW     5
> > +#define PT_COLOR_GREEN      6
> > +#define PT_COLOR_BRIGHT     7
> > +#define PT_COLOR_BLUE	    8
> > +
> > +/* each thermal zone uses 12 chars, 8 for name, 2 for instance, 2
> > space
> > + * also used to list trip points in forms of AAAC, which represents
> > + * A: Active
> > + * C: Critical
> > + */
> > +#define TZONE_RECORD_SIZE 12
> > +#define TZ_LEFT_ALIGN 32
> > +#define CDEV_NAME_SIZE 20
> > +#define CDEV_FLAG_IN_CONTROL (1 << 0)
> > +
> > +/* dialogue box starts */
> > +#define DIAG_X 48
> > +#define DIAG_Y 8
> > +#define THERMAL_SYSFS "/sys/class/thermal"
> > +#define CDEV "cooling_device"
> > +#define TZONE "thermal_zone"
> > +#define TDATA_LEFT 16
> > +#endif /* TMON_H */
> > diff --git a/tools/thermal/tmon/tui.c b/tools/thermal/tmon/tui.c
> > new file mode 100644
> > index 0000000..957ecf3
> > --- /dev/null
> > +++ b/tools/thermal/tmon/tui.c
> > @@ -0,0 +1,631 @@
> > +/*
> > + * tui.c ncurses text user interface for TMON program
> > + *
> > + * Copyright (C) 2013 Intel Corporation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > version
> > + * 2 or later as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * Author: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > + *
> > + */
> > +
> > +#include <unistd.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <stdint.h>
> > +#include <ncurses.h>
> > +#include <time.h>
> > +#include <syslog.h>
> > +#include <panel.h>
> > +#include <pthread.h>
> > +#include <signal.h>
> > +
> > +#include "tmon.h"
> > +
> > +static PANEL *data_panel;
> > +static PANEL *dialogue_panel;
> > +static PANEL *top;
> > +
> > +static WINDOW *title_bar_window;
> > +static WINDOW *tz_sensor_window;
> > +static WINDOW *cooling_device_window;
> > +static WINDOW *control_window;
> > +static WINDOW *status_bar_window;
> > +static WINDOW *thermal_data_window;
> > +static WINDOW *dialogue_window;
> > +
> > +char status_bar_slots[10][40];
> > +static void draw_hbar(WINDOW *win, int y, int start, int len,
> > +		unsigned long pattern, bool end);
> > +
> > +static int maxx, maxy;
> > +static int maxwidth = 200;
> > +
> > +#define TITLE_BAR_HIGHT 1
> > +#define SENSOR_WIN_HIGHT 4 /* one row for tz name, one for trip
> > points */ +
> > +
> > +/* daemon mode flag (set by startup parameter -d) */
> > +static int  tui_disabled;
> > +
> > +static void close_panel(PANEL *p)
> > +{
> > +	if (p) {
> > +		del_panel(p);
> > +		p = NULL;
> > +	}
> > +}
> > +
> > +static void close_window(WINDOW *win)
> > +{
> > +	if (win) {
> > +		delwin(win);
> > +		win = NULL;
> > +	}
> > +}
> > +
> > +void close_windows(void)
> > +{
> > +	if (tui_disabled)
> > +		return;
> > +	/* must delete panels before their attached windows */
> > +	if (dialogue_window)
> > +		close_panel(dialogue_panel);
> > +	if (cooling_device_window)
> > +		close_panel(data_panel);
> > +
> > +	close_window(title_bar_window);
> > +	close_window(tz_sensor_window);
> > +	close_window(status_bar_window);
> > +	close_window(cooling_device_window);
> > +	close_window(control_window);
> > +	close_window(thermal_data_window);
> > +	close_window(dialogue_window);
> > +
> > +}
> > +
> > +void write_status_bar(int x, char *line)
> > +{
> > +	mvwprintw(status_bar_window, 0, x, "%s", line);
> > +	wrefresh(status_bar_window);
> > +}
> > +
> > +void setup_windows(void)
> > +{
> > +	int y_begin = 1;
> > +
> > +	if (tui_disabled)
> > +		return;
> > +
> > +	getmaxyx(stdscr, maxy, maxx);
> > +	resizeterm(maxy, maxx);
> > +
> > +	title_bar_window = subwin(stdscr, TITLE_BAR_HIGHT, maxx,
> > 0, 0);
> > +	y_begin += TITLE_BAR_HIGHT;
> > +
> > +	tz_sensor_window = subwin(stdscr, SENSOR_WIN_HIGHT, maxx,
> > y_begin, 0);
> > +	y_begin += SENSOR_WIN_HIGHT;
> > +
> > +	cooling_device_window = subwin(stdscr,
> > ptdata.nr_cooling_dev + 3, maxx,
> > +				y_begin, 0);
> > +	y_begin += ptdata.nr_cooling_dev + 3; /* 2 lines for
> > border */
> > +	/* two lines to show borders, one line per tz show trip
> > point position
> > +	 * and value.
> > +	 * dialogue window is a pop-up, when needed it lays on top
> > of cdev win
> > +	 */
> > +
> > +	dialogue_window = subwin(stdscr, ptdata.nr_cooling_dev+5,
> > maxx-50,
> > +				DIAG_Y, DIAG_X);
> > +
> > +	thermal_data_window = subwin(stdscr, ptdata.nr_tz_sensor *
> > +				NR_LINES_TZDATA + 3, maxx,
> > y_begin, 0);
> > +	y_begin += ptdata.nr_tz_sensor * NR_LINES_TZDATA + 3;
> > +	control_window = subwin(stdscr, 4, maxx, y_begin, 0);
> > +
> > +	scrollok(cooling_device_window, TRUE);
> > +	maxwidth = maxx - 18;
> > +	status_bar_window = subwin(stdscr, 1, maxx, maxy-1, 0);
> > +
> > +	strcpy(status_bar_slots[0], " Ctrl-c - Quit ");
> > +	strcpy(status_bar_slots[1], " TAB - Tuning ");
> > +	wmove(status_bar_window, 1, 30);
> > +
> > +	/* prepare panels for dialogue, if panel already created
> > then we must
> > +	 * be doing resizing, so just replace windows with new
> > ones, old ones
> > +	 * should have been deleted by close_window
> > +	 */
> > +	data_panel = new_panel(cooling_device_window);
> > +	if (!data_panel)
> > +		syslog(LOG_DEBUG, "No data panel\n");
> > +	else {
> > +		if (dialogue_window) {
> > +			dialogue_panel =
> > new_panel(dialogue_window);
> > +			if (!dialogue_panel)
> > +				syslog(LOG_DEBUG, "No dialogue
> > panel\n");
> > +			else {
> > +				/* Set up the user pointer to the
> > next panel*/
> > +				set_panel_userptr(data_panel,
> > dialogue_panel);
> > +				set_panel_userptr(dialogue_panel,
> > data_panel);
> > +				top = data_panel;
> > +			}
> > +		} else
> > +			syslog(LOG_INFO, "no dialogue win, term
> > too small\n");
> > +	}
> > +	doupdate();
> > +	werase(stdscr);
> > +	refresh();
> > +}
> > +
> > +void resize_handler(int sig)
> > +{
> > +	/* start over when term gets resized, but first we clean
> > up */
> > +	close_windows();
> > +	endwin();
> > +	refresh();
> > +	clear();
> > +	getmaxyx(stdscr, maxy, maxx);  /* get the new screen size
> > */
> > +	setup_windows();
> > +	/* rate limit */
> > +	sleep(1);
> > +	syslog(LOG_DEBUG, "SIG %d, term resized to %d x %d\n",
> > +		sig, maxy, maxx);
> > +	signal(SIGWINCH, resize_handler);
> > +}
> > +
> > +const char cdev_title[] = " COOLING DEVICES ";
> > +void show_cooling_device(void)
> > +{
> > +	int i, j, x, y = 0;
> > +
> > +	if (tui_disabled || !cooling_device_window)
> > +		return;
> > +
> > +	werase(cooling_device_window);
> > +
> > +	wattron(cooling_device_window, A_BOLD);
> > +	mvwprintw(cooling_device_window, 0, maxx/2 -
> > sizeof(cdev_title),
> > +		cdev_title);
> > +
> > +	mvwprintw(cooling_device_window,  1, 1,
> > +		"ID  Cooling Dev   Cur    Max   Thermal Zone
> > Binding");
> > +	wattroff(cooling_device_window, A_BOLD);
> > +	for (j = 0; j <	ptdata.nr_cooling_dev; j++) {
> > +		/* draw cooling device list on the left in the
> > order of
> > +		 * cooling device instances. skip unused idr.
> > +		 */
> > +		mvwprintw(cooling_device_window, j + 2, 1,
> > +			"%02d %12.12s%6d %6d",
> > +			ptdata.cdi[j].instance,
> > +			ptdata.cdi[j].type,
> > +			ptdata.cdi[j].cur_state,
> > +			ptdata.cdi[j].max_state);
> > +	}
> > +
> > +	/* show cdev binding, y is the global cooling device
> > instance */
> > +	for (i = 0; i < ptdata.nr_tz_sensor; i++) {
> > +		int tz_inst = ptdata.tzi[i].instance;
> > +		for (j = 0; j < ptdata.nr_cooling_dev; j++) {
> > +			int cdev_inst;
> > +			y = j;
> > +			x = tz_inst * TZONE_RECORD_SIZE +
> > TZ_LEFT_ALIGN; +
> > +			draw_hbar(cooling_device_window, y+2, x,
> > +				TZONE_RECORD_SIZE-1, ACS_VLINE,
> > false); +
> > +			/* draw a column of spaces to separate
> > thermal zones */
> > +			mvwprintw(cooling_device_window, y+2, x-1,
> > " ");
> > +			if (ptdata.tzi[i].cdev_binding) {
> > +				cdev_inst = ptdata.cdi[j].instance;
> > +				unsigned long trip_binding =
> > +
> > ptdata.tzi[i].trip_binding[cdev_inst];
> > +				int k = 0; /* per zone trip point
> > id that
> > +					    * binded to this cdev,
> > one to
> > +					    * many possible based
> > on the
> > +					    * binding bitmask.
> > +					    */
> > +				syslog(LOG_DEBUG,
> > +					"bind tz%d cdev%d tp%lx %d
> > cdev%lx\n",
> > +					i, j, trip_binding, y,
> > +
> > ptdata.tzi[i].cdev_binding);
> > +				/* draw each trip binding for the
> > cdev */
> > +				while (trip_binding >>= 1) {
> > +					k++;
> > +					if (!(trip_binding & 1))
> > +						continue;
> > +					/* draw '*' to show
> > binding */
> > +
> > mvwprintw(cooling_device_window,
> > +						y + 2,
> > +						x +
> > ptdata.tzi[i].nr_trip_pts -
> > +						k - 1, "*");
> > +				}
> > +			}
> > +		}
> > +	}
> > +	wborder(cooling_device_window, 0, 0, 0, 0, 0, 0, 0, 0);
> > +	wrefresh(cooling_device_window);
> > +}
> > +
> > +const char DIAG_TITLE[] = "[ TUNABLES ]";
> > +#define DIAG_DEV_ROWS  5
> > +void show_dialogue(void)
> > +{
> > +	int j, x = 0, y = 0;
> > +	WINDOW *w = dialogue_window;
> > +
> > +	if (tui_disabled || !w)
> > +		return;
> > +
> > +	werase(w);
> > +	box(w, 0, 0);
> > +	mvwprintw(w, 0, maxx/4, DIAG_TITLE);
> > +	/* list all the available tunables */
> > +	for (j = 0; j <= ptdata.nr_cooling_dev; j++) {
> > +		y = j % DIAG_DEV_ROWS;
> > +		if (y == 0 && j != 0)
> > +			x += 20;
> > +		if (j == ptdata.nr_cooling_dev)
> > +			/* save last choice for target temp */
> > +			mvwprintw(w, y+1, x+1, "%C-%.12s", 'A'+j,
> > "Set Temp");
> > +		else
> > +			mvwprintw(w, y+1, x+1, "%C-%.10s-%2d",
> > 'A'+j,
> > +				ptdata.cdi[j].type,
> > ptdata.cdi[j].instance);
> > +	}
> > +	wattron(w, A_BOLD);
> > +	mvwprintw(w, DIAG_DEV_ROWS+1, 1, "Enter Choice [A-Z]?");
> > +	wattroff(w, A_BOLD);
> > +	/* y size of dialogue win is nr cdev + 5, so print legend
> > +	 * at the bottom line
> > +	 */
> > +	mvwprintw(w, ptdata.nr_cooling_dev+3, 1,
> > +		"Legend: A=Active, P=Passive, C=Critical");
> > +
> > +	wrefresh(dialogue_window);
> > +}
> > +
> > +void write_dialogue_win(char *buf, int y, int x)
> > +{
> > +	WINDOW *w = dialogue_window;
> > +
> > +	mvwprintw(w, y, x, "%s", buf);
> > +}
> > +
> > +const char control_title[] = " CONTROLS ";
> > +void show_control_w(void)
> > +{
> > +	unsigned long state;
> > +
> > +	get_ctrl_state(&state);
> > +
> > +	if (tui_disabled || !control_window)
> > +		return;
> > +
> > +	werase(control_window);
> > +	wattron(control_window, A_BOLD);
> > +	mvwprintw(control_window, 0, maxx/2 -
> > sizeof(control_title),
> > +		control_title);
> > +	wattroff(control_window, A_BOLD);
> > +
> > +	mvwprintw(control_window, 1, 1, "PID gain: kp=%2.2f
> > ki=%2.2f, kd=%2.2f",
> > +		p_param.kp, p_param.ki, p_param.kd);
> > +
> > +	mvwprintw(control_window, 2, 1,
> > +		"Target Temp: %2.1f, Zone: %d, Control Device:
> > %.12s, PID output: %2.2f, state: %d",
> > +		target_thermal_zone, ctrl_cdev,
> > +		p_param.t_target, p_param.y_k, state);
> > +	/* draw border last such that everything is within
> > boundary */
> > +	wborder(control_window, 0, 0, 0, 0, 0, 0, 0, 0);
> > +	wrefresh(control_window);
> > +}
> > +
> > +void initialize_curses(void)
> > +{
> > +	if (tui_disabled)
> > +		return;
> > +
> > +	initscr();
> > +	start_color();
> > +	keypad(stdscr, TRUE);	/* enable keyboard mapping */
> > +	nonl();			/* tell curses not to do
> > NL->CR/NL on output */
> > +	cbreak();		/* take input chars one at a time
> > */
> > +	noecho();		/* dont echo input */
> > +	curs_set(0);		/* turn off cursor */
> > +	use_default_colors();
> > +
> > +	init_pair(PT_COLOR_DEFAULT, COLOR_WHITE, COLOR_BLACK);
> > +	init_pair(PT_COLOR_HEADER_BAR, COLOR_BLACK, COLOR_WHITE);
> > +	init_pair(PT_COLOR_ERROR, COLOR_BLACK, COLOR_RED);
> > +	init_pair(PT_COLOR_RED, COLOR_WHITE, COLOR_RED);
> > +	init_pair(PT_COLOR_YELLOW, COLOR_WHITE, COLOR_YELLOW);
> > +	init_pair(PT_COLOR_GREEN, COLOR_WHITE, COLOR_GREEN);
> > +	init_pair(PT_COLOR_BLUE, COLOR_WHITE, COLOR_BLUE);
> > +	init_pair(PT_COLOR_BRIGHT, COLOR_WHITE, COLOR_BLACK);
> > +
> > +}
> > +
> > +void show_title_bar(void)
> > +{
> > +	int i;
> > +	int x = 0;
> > +
> > +	if (tui_disabled || !title_bar_window)
> > +		return;
> > +
> > +	wattrset(title_bar_window,
> > COLOR_PAIR(PT_COLOR_HEADER_BAR));
> > +	wbkgd(title_bar_window, COLOR_PAIR(PT_COLOR_HEADER_BAR));
> > +	werase(title_bar_window);
> > +
> > +	mvwprintw(title_bar_window, 0, 0,
> > +		"     TMON v%s", VERSION);
> > +
> > +	wrefresh(title_bar_window);
> > +
> > +	werase(status_bar_window);
> > +
> > +	for (i = 0; i < 10; i++) {
> > +		if (strlen(status_bar_slots[i]) == 0)
> > +			continue;
> > +		wattron(status_bar_window, A_REVERSE);
> > +		mvwprintw(status_bar_window, 0, x, "%s",
> > status_bar_slots[i]);
> > +		wattroff(status_bar_window, A_REVERSE);
> > +		x += strlen(status_bar_slots[i]) + 1;
> > +	}
> > +	wrefresh(status_bar_window);
> > +}
> > +
> > +static void handle_input_val(int ch)
> > +{
> > +	char buf[32];
> > +	int val;
> > +	char path[256];
> > +	WINDOW *w = dialogue_window;
> > +
> > +	echo();
> > +	keypad(w, TRUE);
> > +	wgetnstr(w, buf, 31);
> > +	val = atoi(buf);
> > +
> > +	if (ch == ptdata.nr_cooling_dev) {
> > +		snprintf(buf, 31, "Invalid Temp %d! %d-%d", val,
> > +			MIN_CTRL_TEMP, MAX_CTRL_TEMP);
> > +		if (val < MIN_CTRL_TEMP || val > MAX_CTRL_TEMP)
> > +			write_status_bar(40, buf);
> > +		else {
> > +			p_param.t_target = val;
> > +			snprintf(buf, 31, "Set New Target Temp
> > %d", val);
> > +			write_status_bar(40, buf);
> > +		}
> > +	} else {
> > +		snprintf(path, 256, "%s/%s%d", THERMAL_SYSFS,
> > +			CDEV, ptdata.cdi[ch].instance);
> > +		sysfs_set_ulong(path, "cur_state", val);
> > +	}
> > +	noecho();
> > +	dialogue_on = 0;
> > +	show_data_w();
> > +	show_control_w();
> > +
> > +	top = (PANEL *)panel_userptr(top);
> > +	top_panel(top);
> > +}
> > +
> > +static void handle_input_choice(int ch)
> > +{
> > +	char buf[48];
> > +	int base = 0;
> > +	int cdev_id = 0;
> > +
> > +	if ((ch >= 'A' && ch <= 'A' + ptdata.nr_cooling_dev) ||
> > +		(ch >= 'a' && ch <= 'a' + ptdata.nr_cooling_dev)) {
> > +		base = (ch < 'a') ? 'A' : 'a';
> > +		cdev_id = ch - base;
> > +		if (ptdata.nr_cooling_dev == cdev_id)
> > +			snprintf(buf, sizeof(buf), "New Target
> > Temp:");
> > +		else
> > +			snprintf(buf, sizeof(buf), "New Value for
> > %.10s-%2d: ",
> > +				ptdata.cdi[cdev_id].type,
> > +				ptdata.cdi[cdev_id].instance);
> > +		write_dialogue_win(buf, DIAG_DEV_ROWS+2, 2);
> > +		handle_input_val(cdev_id);
> > +	} else {
> > +		snprintf(buf, sizeof(buf), "Invalid selection %d",
> > ch);
> > +		write_dialogue_win(buf, 8, 2);
> > +	}
> > +}
> > +
> > +void *handle_tui_events(void *arg)
> > +{
> > +	int ch;
> > +
> > +	keypad(cooling_device_window, TRUE);
> > +	while ((ch = wgetch(cooling_device_window)) != EOF) {
> > +		if (tmon_exit)
> > +			break;
> > +		/* when term size is too small, no dialogue panels
> > are set.
> > +		 * we need to filter out such cases.
> > +		 */
> > +		if (!data_panel || !dialogue_panel ||
> > +			!cooling_device_window ||
> > +			!dialogue_window) {
> > +
> > +			continue;
> > +		}
> > +		pthread_mutex_lock(&input_lock);
> > +		if (dialogue_on) {
> > +			handle_input_choice(ch);
> > +			/* top panel filter */
> > +			if (ch == 'q' || ch == 'Q')
> > +				ch = 0;
> > +		}
> > +		switch (ch) {
> > +		case KEY_LEFT:
> > +			box(cooling_device_window, 10, 0);
> > +			break;
> > +		case 9: /* TAB */
> > +			top = (PANEL *)panel_userptr(top);
> > +			top_panel(top);
> > +			if (top == dialogue_panel) {
> > +				dialogue_on = 1;
> > +				show_dialogue();
> > +			} else {
> > +				dialogue_on = 0;
> > +				/* force refresh */
> > +				show_data_w();
> > +				show_control_w();
> > +			}
> > +			break;
> > +		case 'q':
> > +		case 'Q':
> > +			tmon_exit = 1;
> > +			break;
> > +		}
> > +		update_panels();
> > +		doupdate();
> > +		pthread_mutex_unlock(&input_lock);
> > +	}
> > +
> > +	if (arg)
> > +		*(int *)arg = 0; /* make gcc happy */
> > +
> > +	return NULL;
> > +}
> > +
> > +/* draw a horizontal bar in given pattern */
> > +static void draw_hbar(WINDOW *win, int y, int start, int len,
> > unsigned long ptn,
> > +		bool end)
> > +{
> > +	mvwaddch(win, y, start, ptn);
> > +	whline(win, ptn, len);
> > +	if (end)
> > +		mvwaddch(win, y, MAX_DISP_TEMP+TDATA_LEFT, ']');
> > +}
> > +
> > +static char trip_type_to_char(int type)
> > +{
> > +	switch (type) {
> > +	case THERMAL_TRIP_CRITICAL: return 'C';
> > +	case THERMAL_TRIP_HOT: return 'H';
> > +	case THERMAL_TRIP_PASSIVE: return 'P';
> > +	case THERMAL_TRIP_ACTIVE: return 'A';
> > +	default:
> > +		return '?';
> > +	}
> > +}
> > +
> > +/* fill a string with trip point type and value in one line
> > + * e.g.      P(56)    C(106)
> > + * maintain the distance one degree per char
> > + */
> > +static void draw_tp_line(int tz, int y)
> > +{
> > +	int j;
> > +	int x;
> > +
> > +	for (j = 0; j < ptdata.tzi[tz].nr_trip_pts; j++) {
> > +		x = ptdata.tzi[tz].tp[j].temp / 1000;
> > +		mvwprintw(thermal_data_window, y + 0, x +
> > TDATA_LEFT,
> > +			"%c%d",
> > trip_type_to_char(ptdata.tzi[tz].tp[j].type),
> > +			x);
> > +		syslog(LOG_INFO, "%s:tz %d tp %d temp = %lu\n",
> > __func__,
> > +			tz, j, ptdata.tzi[tz].tp[j].temp);
> > +	}
> > +}
> > +
> > +const char data_win_title[] = " THERMAL DATA ";
> > +void show_data_w(void)
> > +{
> > +	int i;
> > +
> > +
> > +	if (tui_disabled || !thermal_data_window)
> > +		return;
> > +
> > +	werase(thermal_data_window);
> > +	wattron(thermal_data_window, A_BOLD);
> > +	mvwprintw(thermal_data_window, 0, maxx/2 -
> > sizeof(data_win_title),
> > +		data_win_title);
> > +	wattroff(thermal_data_window, A_BOLD);
> > +	/* draw a line as ruler */
> > +	for (i = 10; i < MAX_DISP_TEMP; i += 10)
> > +		mvwprintw(thermal_data_window, 1, i+TDATA_LEFT,
> > "%2d", i); +
> > +	for (i = 0; i < ptdata.nr_tz_sensor; i++) {
> > +		int temp = trec[cur_thermal_record].temp[i] / 1000;
> > +		int y = 0;
> > +
> > +		y = i * NR_LINES_TZDATA + 2;
> > +		/* y at tz temp data line */
> > +		mvwprintw(thermal_data_window, y, 1,
> > "%6.6s%2d:[%3d][",
> > +			ptdata.tzi[i].type,
> > +			ptdata.tzi[i].instance, temp);
> > +		draw_hbar(thermal_data_window, y, TDATA_LEFT,
> > temp, ACS_RARROW,
> > +			true);
> > +		draw_tp_line(i, y);
> > +	}
> > +	wborder(thermal_data_window, 0, 0, 0, 0, 0, 0, 0, 0);
> > +	wrefresh(thermal_data_window);
> > +}
> > +
> > +const char tz_title[] = "THERMAL ZONES/SENSORS";
> > +
> > +void show_sensors_w(void)
> > +{
> > +	int i, j;
> > +	char buffer[512];
> > +
> > +	if (tui_disabled || !tz_sensor_window)
> > +		return;
> > +
> > +	werase(tz_sensor_window);
> > +
> > +	memset(buffer, 0, sizeof(buffer));
> > +	wattron(tz_sensor_window, A_BOLD);
> > +	mvwprintw(tz_sensor_window, 0, maxx/2 - sizeof(tz_title),
> > tz_title);
> > +	mvwprintw(tz_sensor_window, 1, 1, "Thermal Zones:");
> > +	wattroff(tz_sensor_window, A_BOLD);
> > +
> > +	mvwprintw(tz_sensor_window, 1, TZ_LEFT_ALIGN, "%s",
> > buffer);
> > +	/* fill trip points for each tzone */
> > +	wattron(tz_sensor_window, A_BOLD);
> > +	mvwprintw(tz_sensor_window, 2, 1, "Trip Points:");
> > +	wattroff(tz_sensor_window, A_BOLD);
> > +
> > +	/* draw trip point from low to high for each tz */
> > +	for (i = 0; i < ptdata.nr_tz_sensor; i++) {
> > +		int inst = ptdata.tzi[i].instance;
> > +
> > +		mvwprintw(tz_sensor_window, 1,
> > +			TZ_LEFT_ALIGN+TZONE_RECORD_SIZE * inst,
> > "%.9s%02d",
> > +			ptdata.tzi[i].type,
> > ptdata.tzi[i].instance);
> > +		for (j = ptdata.tzi[i].nr_trip_pts - 1; j >= 0;
> > j--) {
> > +			/* loop through all trip points */
> > +			char type;
> > +			int tp_pos;
> > +			/* reverse the order here since trips are
> > sorted
> > +			 * in ascending order in terms of
> > temperature.
> > +			 */
> > +			tp_pos = ptdata.tzi[i].nr_trip_pts - j - 1;
> > +
> > +			type =
> > trip_type_to_char(ptdata.tzi[i].tp[j].type);
> > +			mvwaddch(tz_sensor_window, 2,
> > +				inst * TZONE_RECORD_SIZE +
> > TZ_LEFT_ALIGN +
> > +				tp_pos,	type);
> > +			syslog(LOG_DEBUG, "draw tz %d tp %d
> > ch:%c\n",
> > +				inst, j, type);
> > +		}
> > +	}
> > +	wborder(tz_sensor_window, 0, 0, 0, 0, 0, 0, 0, 0);
> > +	wrefresh(tz_sensor_window);
> > +}
> > +
> > +void disable_tui(void)
> > +{
> > +	tui_disabled = 1;
> > +}
> > 
> 
> 

[Jacob Pan]
--MP_/m36g8KMQBxpMMIjZkVoJuET
Content-Type: image/jpeg
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=tmon_60dc_powerclamp.jpg

/9j/4AAQSkZJRgABAQEASABIAAD//gATQ3JlYXRlZCB3aXRoIEdJTVD/2wBDAAUDBAQEAwUEBAQF
BQUGBwwIBwcHBw8LCwkMEQ8SEhEPERETFhwXExQaFRERGCEYGh0dHx8fExciJCIeJBweHx7/2wBD
AQUFBQcGBw4ICA4eFBEUHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4e
Hh4eHh4eHh7/wAARCAM1Bf8DASIAAhEBAxEB/8QAHAABAQEBAQEBAQEAAAAAAAAAAAYFBwQDCAIB
/8QAbhAAAQQBAgMCBQwLDAcDCAMRAAECAwQFBhEHEiETMRQVIlGRI0FSVmFxgZKWocLVFyQyU1VX
laLB0tMIFjY3QmJjcnaxtMMzVIKTo7K1JaTUNDhDZGVzlLM1ZmeDhKXRGCZGdIXiJyhERYbE4f/E
ABoBAQEAAwEBAAAAAAAAAAAAAAAEAgMFAQb/xABLEQACAQIDAwcJBQYEBQMFAQAAAQIDEQQhMRJB
UQVhcZGhscETIjIzNHKBstEUUmLC8EJTkqLS4RUjgtM1Q2Nz8QZEsyRFo8Pig//aAAwDAQACEQMR
AD8A/ZYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB58lYkqY6zbip2LskMTpG1q/L2syoiqjGc7mt5l7k5lRN
16qneAegHOcJxTny2prOn4uG+tYbdN8DbqzNoIyq2bdWPeqWlVW7Iqryo5dk7t+hq8N+IWC1lh8d
LHextXMXKiWn4ht9ktiFir3q3o7bu68qd4BYgyqWpdOXs3YwdLP4qzlayKtijDcjfPFt380aLzN+
FDxM15od71YzWenXORqOVEycKrsqK5F+67lRrlTzo1V9YAogYMGtNHTsx74NWYGVuTesdBWZGJyW
3Iuyti2d5aovTZu597mqNM0s5DgrmosRWy0+3Y0ZbsbLEm/dyxqvMu/uIAa4MDA6j8a6r1JgvA+x
8SS14+27Xm7btYWy78uycu3Nt3rvtv07jxY7X2Fu8Tslw9ZDeiy2PqNtukkjakEzFRiqkbkcqq5v
aM3RUT7rpuAVgI/QPEbT2s6mfuY7wqrUwd6SnZsXWsjjfysa/tmKjl9SVrkcjncvRd9kNejqzSt/
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
rsgltRxSqssTFYkiMV6taruZXcnku5kR1GFwtXFVY0aMbyeWR5KSirstQeTD5GvlcdFfqx244Zd+
VtqpLWlTZVReaOVrXt6p03RN02VOiop6zTKLg3GSs0egAGIAAAAAAAAABzyXs3fukq27ndpFo+Xl
Tfps65Hv/wAifOdDOVPncn7raOD+R+8VV+Fb3T5mqdXkqG063NTka6m7pOqgA5RsAAAAAAAAAAAA
JjLa5wFDTmQzzZLFyrj8gmOspBEqPbP27YFaiP5UVGvem6ou2yLtuU5+XctiNEUtE8Q8NUpYXGao
XUm0rKsUcF9tF+TrLG5FaiSJF5UatVPJ35duprcTMNJpXI6xwWharsZj7GFxF69XqRSSNRi35o7U
yRMc1znLA1Ufyua5zW/dI7ZQD9GA/LeQxWBdw61a3Tus9NZLG2lxMU1DTONlpVq0nh8adtutiVGz
ORVReVWr5DVXqm5bZDhxoi9xlvYSbTlBuKh0lFIylFH2cPautT7yq1uyLIm3R69UVVXfddwDtU1i
CB8TJpo43TP7OJHORFe7ZV5U867Iq7e4pi6rzuJo1bFCxC7J2pYXf9mV2drNMxUXfdidUbsi7qvT
4dkPzzVxtfH6E4XaoqwpY1Dn8U5uQtWJpFmvvfT7ViPfvu5zJGsdHuqcqtREVu55+DeTlh4maDSt
aw8UmTdabkatKOR1qNXU5pnQ3XrLytlbLE31NYmLu1Vaq+UdCjQpRo/aJvO+Sva9rZ33a6a8Mrtd
TD4ejDDrFVHmnZRule1s76pK+lr71ldrqHB7N3M7kKlvKxWrNeSt2+HXnWRlSJ7pWoj12RVeqRua
kjt+ibdFd5XXDj/BpzaPD3QeRc90cVjH2KEz2p1RVV0rHfB2T0T3XkDo6RuLw+o8Hw+bp3UeoP3q
3XV9S4Nr23XTsRiMbda7m+2JHORzVV+6uY7yWoecoVvLyjVta60WmrT+vxvqecqV/tM4VtlR2o6L
RWbTt0tX+N3mz9PA/LWEo6fbpfUl3T2s9MTS/vPyLb+KxGFnqTzKsO6PuLJal2mY5Nt3tR68703V
CjymncHgU09Txlt2mYs7onJxZbJ1kVZXq2OpyWZFTrJIxZHqj1Xm2c5N0IDmH6CB+Y6duh+8HVeK
03idP+L68mKky2Y0ckjYLlJ1ra0zlTdWzMgbIr0a968sibrvsh89TwaatYDXNXh8+JmiJocJG52O
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
+9/wXwH97VHxh4Jy9l4R28/Y83L05+y393l5fW2OhtxeMbJekbjqjX5BUW65IWotlUYjE7RdvL8h
Eb136Iidx8dP4HB6epupYDC47E1XPWR0NGqyBiuXvcrWIib+6ASHF6TKw5rh9JhKVK7fTUknZQXL
bq0T/wDsrIb80jY5Fbs3dU2Yu6oidN90oNN29aT3ns1HgNP46okSqyWhm5rciv3TZqsfViRG7cy8
3Mq7oibdd0zOIf8AC7hx/aSb/pORLMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAwdS+TntMP8APkZGL8NSdf72obxzHiTbuQajpri7l50MNyN19Y4+18Ee6JzEWLdf9Isb
3LyIip0a7bddn9Gxa13Yyq6nO6xWWFixSrIsivZsmzlcvV26dd17zo4vDuFClO+q8W8+vLiszq47
CunhqFS+q6s28+vLisz0AA5xygAAAAAAAAASWpvK4kaPZ5mX5PRGxv0itJLO+VxW0qzzY3JSeh1V
v0i3Aetfuz+SRjLQrTmnB/ypYGf6tTtR+9vfnb/lnSzmnBXyr2d80FizAnuK3KZHf9BRhMsDXfBx
7dpeJXhsvKS4Rfa4rxN/iFkYcLPh8zNHKxla1yy2EROzbE/Zj2PX1t0VHp6yrEib7qiLv4bJwZaq
63VZL4Nzq2KV7dmzNTby2eurVXdEVdt9t03RUVfhqDDtzSQ1bc6+LkVVs1Ub/wCU93K1zt/uO9Vb
/K6brtui4FXGZ/R1GdMQ9+dxkfMsGPmerZ67dvJayRd+dqL05VTdE223VNnYRjRrYeME7VFpfS19
L6J9OVnrfIuhHD4jCwpqVqq0vkmm9L6J3zzdrPW+RZgmtM6vq6kmhbiKkz2MRfD3Sp2fgjuqJGqb
eVJzJ3J0ROqr1ai0pFWoVKEtiorPh+v1vOfiMNVw09iqrPhv/XhnoweTMSZKLHSyYepUt3k27KG1
adXid1TfmkbHIrdk3VNmruqInTfdPWf49yNarnLsiJuqmEXaSbV+b/waDnPAnPap1Dpp2Sy9Cg2h
PeyT4bDctLYnRfDpkbErHQtRI2N3Y1yP+5YzyW77Nqq2qMdYkgrRR2Fvyzdk+lyJ20CptzrIm+zW
tRUXm32VFTlV3Mm8P+5Rmml4I4ls6+qtmsvXf1u0mfKieiRD119E08prjIXctJBk7tZtXtZLdVss
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
zXuHOfhqpvaZRknrJ/TRp2kf57WkFkrF7JaqjZRy0fiPLy1bFq92O/gz09Uhid05FevqaIq+skaO
Rf5e/C0ljcLGNR+i31ZPtvLpaSR1+SsNHFudGbslaW/dlK2T1XxbSSN/C0Jm68wFG1s6xj8Vayd7
b/WrUrGtX3tksonubeY8mL/7Hs5mRPJTT2o5pX+7UutZPKv9Vrp3O9+EoNHfbut9YZZeqR2a2Lid
52QQpIvoksyp76KZmoY2Vtd5ytLdiowZnTzJ1llajo0WrK5squRe9qssRNd3LsnRUXqZxqudV0pf
di7c7e1LqU5roI8PXc8Wqs/2pO/Q8murgUmsbcrakOJpzLFcyTlibIi9YIkTeWX3OVvcvsnNT1zn
HietJ+5odabU9SWNdQNhRFRVj8I8LSNPX/0fqe3m6HnZczv7y9R5LKWuwy8WHZicfUdGqPTtUSOK
dyuRHLzyOReiJ3bL1aiN7BBjKcWDZhkiRaTKyVUjXuWNG8u3oPJSfJkIRTvaabtvcVfukrfF7yjl
Gk8HUWGjLOOba4v6K1vi08zO0bflsUJMfcn7a7QckUkv39ipvFN/ts2VfW5kcnrEZrz/APOTMY2r
91UmzMONqp60nZuWxbf73JXdDv63l+yQxKd3O4/SuBvYa14TmYcfNg7tRY1c9fBXvidZ8lFXyJGK
uyoqLzbN6u2Wm0tVhk1lgcfXvMyFXBYF9nt2IiMfJak5InJt5mQTom6quzt1VV6rtWFWDqzxCay2
rczV11OVkuZtbmb8TTjTw32uLV6uSXC/p7suC5m1nZ219L/9n8QtV4lejLfg2XhT1vVI1gkRPedW
Ry+7J7pXEjqb/s/iLpXK90d1trESr6yq9iTxqvvLXe1Pdk90rjiY3zvJ1PvRXZ5v5b/E4sd6AAIj
IAAAGDrjpi6b/Y5Wh89qJv6TeIDjBk7uLp131Zo7KPlgldRcxVc1IZ2SdsitRVRu6I12/Tq3br0d
bydSlVxUIx1udHkmhKvjKcI63X66i/B4dPvfLhq00mRjyLpWdp4TG1GsfzLv5KJ3NTfZO9dkTdVX
dT3Ek47MnHgQ1IbEnHh+t4ABiYA/ixDDZryV7ETJYZWqySN7Uc1zVTZUVF70VD+z5XLEdSnNalXa
OGN0j18yIm6nsb3VtT1Np3Rw2hSsU7uC1liYo5ZrmpMsxjFRESRkqyKxu/rbpXWNq+s6VPW3O2Y3
JU8hi4snXlRa0kfOjneTyp66O37lTZUVF7lRTmVXHT0f3OONsxtdJbxlODNxon3TnxSJaVE/rIit
91HH9a3lu1L1rH4W5BJhs21lq+5Wuc3HMcrUfIvKn+jlTvRVT+Wu6Iqqn1WNorlCps3s4ynFP8Kl
full0NatHdjQePxUsLKVnF5P8KdmvhquLus20fRa6an4h4OzbjV0U8VnJMjcn3FWNng8DVT1letq
SX/ZT2KFJwqbHe4VaagvRR2HQUIIZUkajkWWBEYq7L66PZv7iofHRMfhettSZJZ1ssox1MNDMqNT
n7KLt5HojUROrrKIuyIm7NvWPvwr9RwmTxy99LOZGJE8zXWpJWJ8DJGoSY+o3QcF+xsW5k1J9m0l
8DiVqznXc1lw5krJdiKaenUsS9rPVglf2bouZ8aKvI5UVW9fWVUTp7iH551FSus4xtxdLQWQlfFT
tW4sXHLT8EswxzxRRS7OsJs1ySTboqNVqvZsxyI/f9GnJMkqp+6Dr6g38iB8Gnnr6zUkrWLS+l6w
J8Uy/wDT+JnSlWaV7Qk7O/wWTW99PA30OUsVg/UzavZPo4HTJqtKhTns1qleB8dZWc0caNVGNRVR
vT1kVV2T3VMThBWip8KdJwQxMjamGqK5Gt23csTVcvvqqqqr66qps6ok7LTOVl9hSmd6GKeTh/H2
Wg9PRewxdZvoiacvak8HK71kuxP6kspylLNm4SXC3ycTmI/Yagyf51uR30itJLhp5LdSx+w1Bb/O
VrvpHlHPDVVzxfevExfpIh+NWNpLxJ0PvPm0dcyay3OwzlyFkUXI2o1Y2MlRsTlfajTdiNVd3bqq
OdvX6vrS6dXGZfAySSXoWspLRlkfLJk4k7mOe5Ve6RqIrkkcq7eUrl2VVJniZ9t5HWOZ749N47Hy
Rr7CSKx4bL+bHXX4DrDq8D7Edl0Mbpo2ubHIrUVzUdtzIi+si7Jv7yHWxWJlSw+GU22oppq+TTSk
uyaXNbLOxvwNdYeu5tXW9cVpZ8z61qs7EXpehb1Zjm5XVNqG3Xllc+LExt9Qr7dOSVFRFke1U6o7
ojt+ndto6rrV8bk8fqlK8SspeoW1ViLyQO3TtE8yxq5V39g6Tzm7O1lGrctVMe6eZyOmdDXRjZLE
iN2REVytbzKjUaiucid26ohAcPNbZLVeo9U4m9pfMNo18q6nz2HUezpMSpCroZUjnc9yul7VUVqP
T1RE5kRFRstLyuIc68LKnBZq6WTsmkuOeu+3ErqcpXxCla0M1srJJPVZc2/VvN5m1xSs9lQwESbK
lnUOPjX3U7Zr/olecW1Pn6cFrT+mbNmSSTCajhXdWOWR8Ee/Zry7cznbO5e7dytRybo5N+0mGPw0
sPQpRa12n05qz6rGfKGGnhYwpyWWbT43f0SfxMbXcfbaIz0Xs8bYb6YnH00q5tnSGJe9Ee2WhCrk
VN0VFjQ++oI+2wOQi9nVkb6WqhncNpO24daam7+fEVXemFqkyzwfRLvX9jlaSMPQ2scBFSlwEuS+
2MXKys1JI3o5YXuekCrunejI3I9O9ixuV3Kh49S68np37cenZWZyF8TXukZGqxY7dUb2jpERGPjX
Zzvut0VruvL9zzrE6Avv1dndVyVZM3RxGRgjTH+MbM81l8TeeflfK/ml5FWNjWyOVr1jkRWoitQ7
1gLGGymLZlcP4NNTyDGy9rExESVOVGpzdN90REbsvVNtl7tjuco0cFg6vlYJ1E7Xvayk0nZ2z4vd
wztI+hqYnk+lW8qouo5ZtNq1757rtb01a/RdE5kMPrDOYaKhcy+PqVZ0bHZ7CNJpXxK3ylV7moxX
O7tmsaibqu67bL8eGV2KjUqY1lplvDZGFt7A33MVj7cMidorZEVE9VRFR3VEVyKq7bo7b5a9hTUE
tfQOnJ7tCev2c1y5jrktRMXBsqNTeFzeaRyboyJd29OdzVRrUdMcO9Ly6MwlXQOsMjbknt1YUxuW
TIzywtmij3WKJsrlbA+NeZWcjWJJG1N03Y5DyFOFXBSjUlZtpqCir2z8/i7Ldrs3drNSUX+KOpfD
zilSb3JKz3Pi2tLNu6utczs55L+SpUbWPq2puzmyNha1VvKq9pIkUkqt3RNk8iKRd12Tydu9URed
43XWajssTK0ZpKVKrJYfdrLBFHkI2q5qzIs8jOWNERHLy79VRd0btzcv4h1tV6s1nV1Ljn6ixVJs
0WQhhsZieGGvWWv2KSSRwyc1Zzle7q3lVG9oqq5HO5dWB/8AT8q1ZwrzUYpPO6ee5arXXsyem2fI
eKVXyUXFyte20tL26efs9LI7zrnOTYLwCxVl8IsySrGzFtZzSXUXbfk2TdHNTrv9ztujtt0VPFpj
WuKmxD7mXzUUdp8iulrPidEtbqjVYjXNRzmsX7p67pvzKvKnRPnwlgxFjBQZBktu7mq8aUr0+Rf2
lyCRjU5onOVVVE7lTZVR6Kj93c3Mvy4r18XexS6Ur4qG9mM3IkkMDZHw8qsVnNZlkjVHtYxEaiqi
7u8lnXm2NMKOH8qsHOLunnJWTstcnuSzu2ud20RrYHYVCSbzXnqy38GtODfnccrJePg5cpT5nWCM
l57Uudt9GtVUSKOVWtVV22TdyvRN+/lXbfZTpBzbg7w5u6FlndayK3ln7dHubbnSNE7ZeyVIFXsu
ZYkj5ncvM1yORHOa7p0kn5ZlQnjJOhLajln0K3VkS490nW/yXeNkk9+SSzW55aZ9LPlbq1rkTYrd
eGxG2RkqMlYjkR7HI9jtl9drmtci+sqIqdUPqAcu7tYiJLh/6hmtZ4/uSDOrIxP5s1WvLv8AGe9P
gUrSSwf2vxV1PW7m2cdj7ie65XWInehImelCtLMf61PjGL64q/aYx0OQ8YdGT6k4gaXq4nO5jF3Z
n2shNNHlraRxsggSFOSFsqNZu6eNrlZyOVrn+UiuXekxWtKWnsY/F60Y/B3cZRfK58s0lmK3BCzd
8sMzt3zKjWq5zXbyp1VUXo5fYz7a4yS+umM0+xPeW1Yd/wCEQ+HGTQFDiFoy9ibLHuuJUnTHc16e
GBllzNo3yMjds9GuRq+U12yb7J1VF6yxVKqsPhMa35NJZrWN22nnk1ZrJ6LS2/XstXlHUotR4qHK
4/kfO6pPC7ta1tm3PXkRF2em/TzoqL0VFVF6KS2idVZLOZeCjkpYKL4InPajGLy5VEVze1iVyf6J
E2dsm67qnVGp5Xy0FD+92exoDUdi7kJrPaTUruRuS2kycHKiOaqyudyyMTZHxt2aqLztaiOcjabW
UWAjwEt3PrFXpUG9sljdWvrqnRHRub5TXesnL1XfbrvsSOMKLeHknNS9GSW570s734XyfCWnWwmM
pKg6VaN+Dy83ja+t+GVtVnmfTP6ixeFesNyZfCVpz3IoWsVVkjhdG1+y7bb800TUTfdVf0Rdl2/3
SePmx+Fjbc5VvWHOs3HJ3LM9eZyJ7ib8qe41D82ZjSur8nq5uas5TOyR8syLXs5qdjoVmlbLFCrk
Xkr2HdnGqNaqRtckKKiKic36X01m6GoMPFk8dI9YnqrHskbySQyNXZ8b2r1a9qoqKi9yoU8q8mQw
GHh5Ke3tek1onuXxV3z69GWKoSwlCMG09vzsr6L0dUratta6XSyvpHkxOSpZWq+1Qm7aFlies53K
rdpIZXRSN2VEXo9jk37l23TdNlJfiTdmyMSaKwr51zWRjSRZYLMsHgECPTew+SJzXom6bNYjkWRd
2/c86pI8NdPXOFuZdT1HlMjkaOVuWWUMjNlLM0cT5bDnsinje7s0lkTld2qMTeR0jVXdzVfJR5Oh
PCupKdqn7MbarO71/Vna5yXNqVtx2E8l/JUqNrH1bU3ZzZGwtaq3lVe0kSKSVW7omyeRFIu67J5O
3eqIvqe5rGOe9yNa1N1VV2RE85wTX2Ntat1FhNeUbuVqaYr52nBs3M3IVvRzL4KtmFjJEbC1FlYj
VYjFe10rlVUcnNhyXgYYuo1Vlsxtr+JrzVqs2/0ldr2cnFZHfAfKlXjp04KkTpnRwRtjYs0zpXqj
U2RXPequcvTq5yqq96qqn1Oa7XyMwADwAAAAAAAAAAAAAAAAAAAAAHIOM/D3A0uD2tLkN/VrpYNP
35WNm1Zk5o1Vtd6ojmPsK17enVrkVFToqKh18jOO38SGvP7N5H/DSFmAAAAAAAAAAAAAAAARnEP+
F3Dj+0k3/SciWZGcQ/4XcOP7STf9JyJZgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAwZfI4hVv6fEy/mSx/tDeMHK+RrjBS+zq3IfSsL/8spw2cmuaXc34FeDznJcYy7It
+BvAAmJAAAAAAAAAASXDvrkdYSez1BJ81eBv0StJLhp1bqST2eoLfzK1v0S2hlh6r6F238DF6o9+
sfK8TQ/fMrB+bzP+ieCPyeMU/wDSafj/ADbD/wBY9+p/KzWmYvPk3vX3m1Z/07Hgm8njFV/pNPzf
m2Iv1iih6vZ4wk+3+xXicqNJdL7WvArQAcomPLl4fCcTcr7b9rA9npaqHl0hN4TpPD2N9+1owP39
+NqmoYPDzpofDxfeajIfiJyfRKI54eXM12p/QrjnhZc0l2qX0N4ktD+qat11Y9ZMzDC1fcbQqr/e
9xWklw18t2p7X3/UNrr/AFEZF/lm3D5UKz5kv5k/AieqM7jDW8YY2fH7b9pg8q7b/wC4JH/mHq11
kVdwPzmUau7n6bnnb7qrWcqfOp78zXS9rGKovVPEluNf/uskKfQJG1YW7+5kxbnfdXsFQgcnuzNi
Yqfn7HUwqU4YeL3Tj/M39CnGZQpr8P5pPxOmY+ulShXqt7oYmxp8CIhM5D1LjDhHetZwGQavvxz0
1RPQ93oK0ktT+pcR9HT/AHxL1b40TZNv+D8xzME3KrK++M/lbJpaDU3qvEnR9f72y/a+LGyPf/jf
OVqoioqKm6L0VCSuercYsUnrVdP3V+GWxV2/+SpWnmKyp0Vwj+aT8RHVklwbVU4U6YhVVV1fGQ1l
388TUjX/AJStJLhH5OjVrf6rlMlW28yR3p2J8zUK0cpe2Vfel3sQ9FGDm/I1fp6X2fhMPpjR/wDl
m8YOqfIyump/YZRWr7zq07f71Q3jXW9XT6PzMtxHqqXuv5pElxO61MBH7PUFD5pUd9ErSS4j9Z9K
x+z1BX+ZkrvolabK+WGpL3n2/wBiJas5pxHRZNE8VZU6rHiZY099tHtPpm7nFSbippSJOqMxuSs/
FdVZv/xTL1RH4Rw94mO7+3jvN+LSZH9A9lOTwrifhpe/sdMTO/3s9f8AZfMdVeqT+6p9tKK7ynH+
utzQXUkWxJcNPIZqSt951Bc6f11bL/mFaSWhPU9Ua6r+smcjkb7z6FRf+ZHHKw+dCtHmT/mS8SZ6
ocNfVHant/f9Q2uvn7NGQ/5Q4mepw6dt/wCr6gpdfN2j1h/zRwl8vSEtn/Wcvk7G/nR96dzfzVQc
XPJ0Utj/AFXJY61v5uyuwPX5mlv/AN02PxbPw9HuMf2Llac90vj/AB3wo1DCreZc3YzCp/OZLYnb
H+ZyIXeRtR0sfYuy/wCjrxOlf7zUVV/uMDhRVkp8MdMwTf6ZMVXdN7sjo2uevxlUloTdLDSmtdqN
vgpP6HrV2e7Q2Q8b6KwWV5ubw3HV7G/n542u/SZXFj1XTFXHp338vj6yp52LbiWT/hteOD/qfDzH
Uvwe+xj9vN4PPJBt8HZjXH2xqrRWP70XLS2pE87Iqk+3/EfGb4QVLlKWzpCUn/Dd+B5e8Bk/tbi5
g5u5l3DXq7l8745a72J8VZStJLXn2vqPReQTokeZdXkX+ZLVnYif7zsytJcVnSoy/D3Sl4WMo6sj
6jG3uLmY52o+KlgqkGy93NNNO56fFij9J9ODz3rwxwFeRyukpVG0ZFXvV0CrC7f3d41P50L9sao1
rke9H5eOrGv8yKrAi/8AEdKOGPqEGocX3eA6gupt5kmelpPmsIW4rOjOC/ZVN/ytP+aRjHW/SVkr
2RROkkcjWMRXOVfWRO9TlGiWPqVuF2XkarJMpXuRy796OuRLdci/7UHpQtOKdyShw11Jag/07cZY
SBPPI6NWsT4XKhm69px4fTOm5IekeGy+Na1fMx0razl+Bkzl97ccnZUlH95JxXTsNd80J69H68C3
JLiT9sP0xiu/w7UFZVTzpXR9v/8A10K0ks79t8U9M0+9tSjevu9x3qMLPSk0voUi5PyrbXBSfxUW
122Mp6DhH6lomLHL0XGXbmPRPM2CzJGz0sa1feVCtJLQv2tqbWeMXojMsy3En8yatCq/8RspWjlH
PEyn97zv4lteIhockzXlazyGp/WxurMZQY/+Y6u2Bfg5shInwKdNy0cEFO9fSGNJ/BXNdKjU5la1
HKiKvfsiqq7e6pzWaKS1wM1RmImq+ee1kcxCid7uysvkg293kiiOg6osxu0ZlLcTkdGuOmka5PXT
s1VFOlj05Spx3xlsfCKiu+7MYNq9t54OE9aKnww0vBDEyJqYms5Ua3ZFcsTVcvvqqqqr66qpTGNo
WPstE4KL2GNrt9EbTZOTjJbeIqSe9vvM021dklw16LqaP2GoLXz8jvpDhb6ticvkP9cz2Rei+dI7
L4Wr8WJD/OH7mx5HWaOVGtjz71VV9ZFq13fSP64Otd9i/T1h6Kj7lJl16L380/qq7/C9To4zKnVl
xcO2Lf0MI6r4n8wfaXGG0zublsFHI1PO6rO5rl9/a1GnwIMv9ucWMBV72Y/GXLr/AHJHuiij9LVn
9A1l9qa10ZlO5HXLGOkd5mTV3yJ6ZK8Se+qDTn25xM1Zf721IaWLb7jmMfYd6UtM395AvQVff5N9
/k+5oc3P/crXNa5qtciOaqbKi9yoRXCOnSbwxqYaarXWGi6xjbEbo05XrXmfC5XJ66u7PdVXv339
ctjlmYuz4XBcTsdVdy2fCO1x6eZ9yvGxnpsdoaMBTlXpyoRdm3B9uz3zRm5uDTTKbhCiy6Dp5Rye
Vl5Z8qqr38tmZ8zE+Bj2p7yIfLiBXgZqbR2TsQxyxNyT6UyPajkRk0TlYvX+mir7e7svrFTiqUGN
xdTHVm8sFWFkMaeZrWo1PmQnOLzHpw9yd6JqulxfZ5SNETqrqsjZ9k9/s9vhMqFdVuUNpZKba6FK
67EzzOMbrVeB8eIteC7mdJ45YY3TWsxG97+VOZsNdrrS9e/l7SCFNvOqFkR7nsyfFyosbkkhxOCf
NunVOa3MiMd8WrJt7jlLA0Yu8adKm9yu+ltv5dk9Tb1I3Q1eChrPWOO7GNs3hsV2J/KnMsE8aLsq
9+3bssr8Kn+cNa8EuS1Vmq8McUNvMSV4EY1Gp2ddEid3eedLDvfcp5tYZODSuvGahtLy07On7bbC
77buqKk8afEksr8BucN8ZPh9CYWhcT7cbUY+2u3fO9OeVfhe5y/CW4qTWHda/rFBdNvS/miuvnMV
Jt7Len6XYzxcXGOj0NaysTVWXDSw5VvKm67V5GyvRP6zGvb/ALRWRvbIxr2ORzXIitVF3RU8587l
eG3UmqWGJJDNG6ORq9zmuTZU9Ck3wnsTTcP8XXtPV9rHsfjbLl73S1nuge5ffWNV+Ehfn4P3ZfMv
DZfWe6SKkAERkAAADG1bjIr2n8wyKFiW7NCSBJUanP0a5WJv37I5VVE86myDZSqOnNSjuNlGrKlN
Tju8Mzw6ekrT4SnaqQxQw2Ym2EbG1Gt3kTnVdk86uVfhPcYPD/yNKVan+pPlpbeZIZXRJ8zEN4yx
MditOPBvvNmLhsV5xW5vvAANJOCc4oWPBuHGo5ebld4ssMYv850atb86oUZH8YofC9DSYxr+V9+9
Tqt93nsxoqfF5izk+Kli6Sem0u8owkFOvCL0bXeb+FxsdTTVLESsR8cNOOs9rk6KiMRqovoJ3hMl
evoGGtYbE2fHOlx12RzURZFquWvzvX192RNXdfWVCzOTavnlxa6/05XesU2bWlJRVO9r721Jyt/q
viWRfNzblWCjLFqdG9nJxfbsv5r/AAJ6tWW05vfe/eVPBusyHh7j7jYGweM1kyXZo3l5G2JHSsZt
63KxzGInrI1EP70X9r6y1tR7kdkoLjE8zZKkLF/PhevwqVNWCKrVirV2JHDCxI42p3NaibInoJal
9rcYMozubfwVSRqfzoZ52uX0TMT4EMfLfaJ4if3k3/PF9iuYO+VytOR5LrovVOqU74NWpkef+ZSs
QwSfB2dV7fhU63I9scbpHuRrWoquVe5EQgtE4nx3wLr4+duy53EzTSo71luNfI7f4ZVMuTasaEXV
em1BPozb+VHk1fIouIUnZaB1DLvtyYuy70ROPXpiPstNYuL2FOFvoYhG5vLvyv7m/I5yRVSWzpKa
xJv3o9ajlci+6i7oXtGPsqUEXsI2t9CGqvTdHD+TlqpyXUl9T1O7ufYkuHnk5PWMfsNQP/OrV3fS
K0gMblI8D9lHLS7dnjskttUX2LcVTevzopjgoSqU6sI6tL5orxPZZNM/zTOOTUOitYyuRHfvivZF
iKv8qNqLUjX3lZAxU9xSk4fZFcvoPT+Vcqq65jK87t+/d0TVX51HD/FyYTQ2DxM26z1aEMcyr3uk
Ric7l91Xbr8Jm8IfUtER0F6Ljr12ht5mw2pY2/mtavvKUYycatOq46RmrdFpLujExjk0VxyLgwxt
HULb6NRrNZY+fM7on3cjbkj+b3VWK3A1P5sSeY6BxDyT8PoLP5WPftamNsTRoner2xuVqJ7qrshP
Z7Gs0ziNC2Itmx4K5Vx8ip3djNH4Jt73PJE7/YM+T/Z503/zHZc7im0v4nET1vwMviHgrrtYab1A
vgbsq/NNq049lSJIGwzyoj3bcyucse+/VG77Ii7KrupElrzytTaDj8+fkVfeTHXV/v2K0nx1aVSj
QUt0X1bTVuwrrYupiLKf7OS5lw6Pqz+ZmJJC+Ne5zVavwkTw7y1fE8B9O5u87lr0tM1rM6+ZrKzX
O/uUuDkWJ+3eEHD/AEq3quWWpVmb/wCrwN7aZF9xzIVj/wDuiGeApKtRcJabcb9FptvqRLJ2Zd8N
cZZxOiMZWvt5chLGtq9/+szOWWb/AIj3HNeJNvXGlNd0mcP8DkUq5vIPjtRPWmtWzYWpNIssKPnR
7Hpyq97XJG2R0CeUnMqv7YfKerWsS15Z68MslaRZYHvYjlierXMVzVX7leV727p6zlTuVRhOU/I4
mdepBTU9q6el3pldaP8AtnmJQukkzJ0Rh62F07Xghr2oZ508ItuuPY+zJO9EV7pnMVWuk36LyqrU
2RG+SiH01niaGc0vkMbksbLkoJIXL4NC5rZXuam7ezc5zWtfuicrlc1EXZd07zXBC8TU8t5e/nXv
8e8zWWhwfh+zW2rtZWcNxAwV6zhNP5NqVnvZRajZW1IXxpZSOZyr5LmybRo9qvn6q1rEanc2VqzH
zvZXia6wvNMqMRFkXZG7u8/RETr6yCCrWry2JYK8MUlmRJZ3sYjVlejWsRzlT7peVjG7r6zUTuRD
6lfKXKLxtRSjBQiklaOSvvdrvV59R5DairXf6zOS8dI83pHAWtW6AxVmLJVcVPHalrpXSqytFGqt
dKyR7VV0e6vjVjHr5LmKmzio4WY7Ix0LeZ1Fir1PUd+VPDn3HQOVyNTdjIuxlka2BnMrWtVyO3Rz
nJu5VWtu1a16nPSu14bNWxG6KaGZiPZIxybOa5q9FRUVUVF7z6mdTlSU8GsM4K985Z7TWVk3fNJ7
rcOBjs3m5NgAHKMwAACSufa3GHGO7kv4G0xV87oZ4Fanonf6FK0ktZfa+ttE3e5H37NJy+ZJKksn
/NA1PhQrS3F506MuMe6Ul3JGMdWSOj/tnXWtb/ekdurj2r50jrMl/wCaw5Pf3K4keFfq2GyuTXvv
5zISovnayw+Fi/CyJqlcOUMsQ4/dtH+FKPgIaGLrbD1s1p2xBNXtTTQp4RUWo9jLMc7EVWOhc9Ua
2TfoiuVG9dneSqnLeGtvXOq9dXY+IOCyK1cJkGR1YmLTSrWnSpDIksyMnc9715kexrUkbG6dfKXl
RWdsPlBVrV5bEsFeGKSzIks72MRqyvRrWI5yp90vKxjd19ZqJ3IhvwnKbw9CpRcE9pZN3vFu17Z5
XWv0un5KF2mfN1Ci6pNUWnXWvOrlliWNOSRXKquVydy7qqqu/fucn41WNW6SycWoOH+EuyWb1qjD
kV5qqUrbn2Y4mMckkqPZMu7Yu0RipySJu5FY1WdhPlbq1rkTYrdeGxG2RkqMlYjkR7HI9jtl9drm
tci+sqIqdUNfJ+O+yV1UnFTjvi7tNb7q64ddnuMqm1NWbJzhtiZMfgVuZCpdhzWQkWfJyXuyWxLK
iq1FXsnvY1iIicjGuVGt2Tv3N/LY+llcbYxuSrR2qdmNYpoZE3a9q96KekE1bETq1nWeTbvlu4W4
W3cAkkrHAcPJxBzOup9Caiw2fm0hWrU5JI5paK2nwPlnazwqRtheaNeRWv5Fe57a6btTtHc3U+LN
Zz+F+oEqxp2tWg+zXY1NvLhTtGInm8piFMyrWZckusrwttSxsikmRiI97GK5WNV3eqNV71RPW5nb
d6i5Xit1JqszeaKaN0b087VTZf7zpYnlby+IpVVTUVCztHJN5XerzbWvCxhGnZNXP9qzR2a0ViF3
NHKxHsXzoqbop9CX4S2JbHDPTqzu5rEOPirzr55Ym9m/85ilQczE0vI1p0/utrqZmndXAANJ6AAA
AAAAAAAAAAAAAAAAAARnHb+JDXn9m8j/AIaQsyM47fxIa8/s3kf8NIWYAAAAAAAAAAPHmvGa4qwm
FWmmQ5PtdbaOWFHfzkb1VPePYeXLuyLMZYfiYKs99I1WvHamdFE5/rI57WuVqe6jV94A5pjeJGdg
4K29XZWljrechydjFRQVWvhrzWEyDqcPRznua1Xciu6r032N3RWotS/v1yWjNXtxMuQgx8OSq28Z
FJFDNDI98bmqyR71a5j2d/MqORyLsnVCSwXDvW9nhhmdHagXT1CeTJSZbGXKFyayjLLrzrrEkY+G
PZjX8jd0VVcm/RCt0Vp3Uv79clrPV7sTFkJ8fDjatTGSySwwwxvfI5yvkYxXOe9/dyojUaibr1UA
+vEP+F3Dj+0k3/SciWZz/i9icVnM1w+xebxlLJ0J9SSdrVuQNmik5cVkHJzMciouzkRU3TvRFKDT
eiNF6avPvac0hp/DW5IlhfPQxsNeRzFVFViuY1FVu7Wrt3bonmAKAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwdR+RqHTMvsr0sS/DWmd/exDeMHWHkyYOf71lovzmvj+m
U4X1luKa600V4L1tuKkuuLRvAAmJAAAAAAAAAASXC7riszJ7PUGS+a1I36JWklwn66Yuv9nn8wvw
eMrKJ8yIW08sJUf4o90voYv0ke/N+Xq7T0fsfCZfRGjfpngv+Txiwv8ASafyH5til+se+95ev8S3
1o8ZcevvrJWRPpHgzHk8XdMv9lhcpH6ZaK/RKMPrFf8ATn3TZXi/VUuj88itAByiYGDoLpp5YvvN
65D8SzK1PmQ3jB0Z5MeWg+9Zaz+c7tPplMM6E1zp968Sunnhqi54vvXibxJcJvL0tasevYzeVl38
6Lfn5fzUaVpJcHfK4a4af/WY32ff7WR0m/5xsp+x1Pej3TIn6SPfX8viDd/ocVX/AD5Zv2ZBVOvA
7TGP9dMvjKW3uRZKJrk+LG4vcR5etM9L7GGpD6Ekf/mEFjeundPY3za7uxbe5FbuSt/Njap1cJlZ
/ddN9UJMp5Q9ZFfhj2xj9TrZJa99T1Hoez6zM69jvefRtt/5laVpJcT/AFOngbX3jUFDr/7yZIv8
w5XJ+eIUeKa6014k09BR9W4xZhe9KuAotT35LFtVT0RN+YrSS0v6rxG1jY+9+A1d/wCrCsm3/G+c
rRj/AFkV+GHypiOhJcNPU26lqf6vqC3083aK2b/NK0ktEepav1zW8+XgsNTzI+jWb/zRuK0coZ13
Liovrin4iGhg618ipjZ/vWWqfnytj+mbxg6/6aXll+82K03xJ43/AETeNc86EHzvw+pbUzw0HzyX
yvxJLiD1zOio/Z6gT5qdp30StJLXXlaq0Ez/ANvSuX4Mbd/SqFabMTlRor8L+aX0Io6sh5I+34aa
sd3+EOyye/s+Vif8p59CyeFa5WXfdIdI4pf97JaX/LQ0sJH2/DGx/wCs17cnv9o+R30jC4MSeFXb
dzv2wOFg396B8n+b851X7NieZ98oruKeUfbJrnfY2dLJLTHqXEfWMPdzto2fjROZv/witIHK2vFm
u9ZW9+VE0rUsJ78Ul7dfQrfQczAwc41YLVxXzxJpZWNHg35XCzTc/wDrNCO1/vU7T6R/vGRF+xTq
iVqbugxc9hqJ542K9PnaaHD2r4DoHT1LbbwfF1otvNyxNT9B9NcVfDtF5yltv4RjrEW3n5o3J+k2
uslyn5Xdt3/mueW8y3MZvFqw+LhbqV9d3qs2MmhgVPZyMVjPznIU1WCOtWirRJtHExGMTzIibIQG
pLXjPhhpdqLzLlreHRf5zFnhlf6WNedDNeIg6WHjB67U+xRX1Cd3ckuG/qMuqcb3eB6gs9PN2zY7
P+fv8J/l/wC2eL+Jj720MHblcnmdNNXaxfRFInwqf7pr7X4lavp93bxUMht5+eOSDf8A7r8wwX2z
xT1Rb721qGPot9xyLPM70pMz0IVVMq1Srv2E/jNRT+Zni0S5xxa9S0jHfTouPymPuKvmbHbiV/5n
OnwlaTvE+k/JcONS0Yt+1mxVlsSp3o/sncq/Auynrfm4U0YupOnYpjvDvc5ez5/7iRxdTC01HXak
utRt3My0kzI4Seq6SlyC9VyGUv20XzsfblWP/h8ifANMfa3EnWNHu8IbRyW3n7SJ0G//AHX5j2cM
qL8Zw503Ql37WDF1mSqver+zbzKvuqu6njn+1eMdRe5MlgJmqvnWtYjVE9Fp3zlNSSqYjExj+0pW
6FJS7omKySHFb1bT9DGJ35DNY+uqediWY5JE/wB3G8+3FuvLZ4ZajbA3msRY6WxAnnljasjPzmof
HWP2zrjRWP70juWcg9PO2KtJGnodYYvvohVWoI7NWWtM3milYrHp50VNlNSq/Z44eXBuf81vyntr
3P8AKdiK3ThtQu5opo2yMXztVN0/vJfE/bfFnP2e9lHFUqjPce988sn5qwn04RzyT8MdOpO7mngo
RVpl88kSdm/85inz4d/bGQ1ble9LeeljYv8ANgiir7fGhevvqo8l9neIjw8347S8Exe9j/K32pxh
vM7m5PBQSNTzurzyNcvosxp8CG/qPIsxGnsllpNuSlUlsO37tmMVy/3GBqr7V4h6NyHd27ruMVf/
AHkPb7emoh/vGD1Th5kcenfk3wYzbz+EzMgVPRIpl5JV62HUv21FP4Sce5IXsmejRGFbV4Y4bAW2
qvLiIa1jfvcvZI16r7qrv6Sex12WX9zitiw7exDpiSKdf6WKu5j/AM5rjoxym/J4HwV4l4/uXGeO
2onmbI2SyxPgbO1E9zY3YObxM23q6kH1tp9rR5Lzeo6Rp2PstP46L2FWJvoYh7j51Y+yrRRewYjf
Qh9Dj1JbUmzYjmdy8uKwXGC81VR1S1LOzbv3TEVHJ85faeopi8Bjsa1ERKlWKBET+YxG/oOZar8q
DiFQ/COexVTbzpYjpQL8yqdbOvyllQp89uynTt3s1w1f63skeLnqOjHZROi4q9UyKu8zIbEb5PTG
j0+EcLPtjEZXLr35PN3Z0X2TGTLBGvwxwsX4T28RqGWy+j8jhsRRx1yTI15akzbt19ZjIpI3Nc5H
MikVXJunk7Ii7r1TbZcD9z+/Nu4VabTKY/H1q64enJVmr332JLCPiRznytdExI3Lui7I5/Vy9em6
+xV+SZNNXU1vV7NcL31V9Ocf8w6Acm4iRS/Zr0viWROdBqJkMlhyfctTGSustVffdKxDrJD5XhXo
jJaxg1Da0tp2XavaZagkxML/AAqaaSF6TvcqdXt7KRN1RVXtndU676eScTRw9aUqzaWzJZK+dns7
1pKzXOs7antRNrIuD43a0NylPTsN54Z43RyN87XJsqehT7HkzGLxuZx0uNzGOqZGjNt2ta1C2WJ+
yo5OZrkVF2VEVN/XRFOZBpSTbt0fpd5mzm/7nR929gspk8lHIy3FYiw6rInVyUoWQvd7yzduqe4v
nOpklw+4faa0YyeTF4fEQ3prFt63K2Pjgl7Gaw+ZsHM3qrGIrGIm+20beidEStOhyviKWJxk6lH0
XplbJZLe9yMKaaikzkn7pLE5/MYbDw0aGNkoQZnHq+aTKS15numnSq6DkbA9Oze2fZzubuc7yHbI
juoYeTJS46KTMVKlS8u/aw1bTrETeq7bSOjjV26bKu7U2VVTrtuvrBrrY51cLTw7ivMbaee+2Wtt
1/pv9UbSbPlddZZTnfShhmtNjcsMc0qxse/byUc9GuVqKuyKqNdt37L3HKeEua1IvE3XWmbeHw9e
KrlIbtxYsxLMtfwinG5GwtdXakjVexXO3WPZZHdHbbu62SGe/wCzuJ+nMinSLJ1rOKl/nSIiWIfQ
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
ERNkQ5l+5gp+BcG8axU2c+5fcv8A8ZMifMiH2k4t6IvafV9PiXoHEZSTZY0t5evaZEnN3PYyaPmc
rfWR6Ijl73InWN4E670rp/TTsdmOLXD59CC9kmQwNnir2FXw6ZWzK91pyLG9N3tajE8l7PKdtu7G
lsx5OrQc0ntwyzzsp6NJrfx8L82pFxq2e6/gd5OU8ea8k2puG3I3dsmp4IpP6rVSf++unoKP7LHC
z8ZejPy7W/XObcT9e6fymrNJyYzi9w2bQr5zt4Ue5k7qito2fVJntuNRzFd5KIjY9nSM6rts7HkS
caeLU5SUbKTzv918EzGorxsd8BD0uK3DVlOBl3ijoaa02NqTSQ5ivGx79vKVrFlcrUVd1RFc7bu3
XvF3itw1fTnZS4o6GhtOjckMk2YryMY/byVcxJWq5EXZVRHN37t07zl2W1a5sJ7gy1z+JfEFHNVG
ULiVY9/WdJZtWn7e+k8foOsnAuGWu9O4zWmrbmT4ucNXVLWYbJOkbmQOt/aNdEfC91xyNYjlVq7t
fu5knVN9m73Gfibw2v8AB7WlGjxC0lat2dP34YIIczXfJK91d6NY1qP3c5VVERE6qqnV5bnCpi9u
Ek04w0vrsq+qW/P48TXSVom7x+yPiHREGp9+XxNkYLPN7Hn5oN/+MVWhsd4n0VgsTy8vgWOr19vN
yRtb+g5B+6H1xonU3CvO4zD8U9BoxcfNLLVW5DZntPjRJI44VbYbyOVzNurZN+ZNk6dbPT/FPQ8F
N7M/xc4d37SyKrJKN6GqxGbJsisfZlVV33XfmTvRNum65VZU3yXTSmtraldZ3slG262rk9d/SFfb
Z0Q5JD/5xcmE9ZFfqLl832nHR5v709JUfZY4WfjL0Z+Xa365yrD6ywn2b7eor/GThk9IcHSqPmja
yOKxC6zYfJFGq3XcsreRqq7d6IkjN2dPKckTpwjXlOSXmNK987tLcn+viKl3a3E/RBM8Vqkl3hnq
WvB/p1xdh8HuSNjVzF+MiHi+yxws/GXoz8u1v1zL1PxO0Jdxi1sLxa4dUpnu2lfevQ2o3Rq1UVqM
ZZiVFVVTrzL0RU267pzsJPydeE27WaefNnuuzOSujR4M248rpa5qGLrHmMvdtRr7KNJnRRr8LImK
Wxw3gFr/AEXgeF+Ax+b4paBRrMXWWGoy3FWnquVnNIyZX2H870VyIuzY9lRenXZL/wCyxws/GXoz
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
C4bI4ZMI7FzZWjRustwyvncli1HCqxq17Wt2R++683VO4AvAfK54T4JN4H2XhPZu7Htd+Tn28nm2
67b7b7HNNB69zF7Xl7TeUzGks7UqY+S1ayOC52R46VkjWdhY55JGo5yK9U8pFTsnbtTvAOoGdqHD
1s5QipW3zMjjuVbiLEqIvPXnjnYnVF6K6NqL7irsqL1ITQ+vs/qfXuZxbMfRrYhcLBlMI+RkiTzM
klmibJL12Rr1h52ojUVGPbv13RP80zr3OU9NcQclrSPFyy6PtTNeuLikiZLEynDZ22ke5eb1RW79
EXZOiGUJypyU4uzWYaudNM7TGHrae01i8BSfNJVxlOGnC+ZUV7mRsRjVcqIiKuzU32RPeIPTWrdc
xahw+G1XVwCS6ixU93GrRZK1Ks8SRudXm5nO7ROWVF7RvL9w5OXuPXw/1lmJKWtZNdWMNX/evkXQ
TWaEMkcKQNqQ2Fe5Hvcu6dq5FXpuje5ApyUXC+Tz6r/VixY4nD1sZfzF2B8zpMtcbcnR6oqNe2CG
BEbsibJywMXrv1Veu2yIy2HrZO/h7s75myYm465AjFREc90E0Co7dF3TlnevTbqiddt0XC0vrypm
8zDibOBz2Ds26z7dFMpXZGluJitR7mcj3bKnOxVY/lfs7fl79tOrqBJ9eZHS3gnKtLF1ch4R2m/P
28tiPk5dunL4Pvvv15u5Nuuflqm1tXztb4WtbqyPLI9Wp8PW1DprKYC6+aOrk6c1OZ8Koj2skYrH
K1VRURdnLtui+8aJyrWWvNYV8nrCfTFHCy4rRkLH5CO42RZ7z+wSxJHC9rkbFyxOZs5zX7uXbZET
cztTcVs9FHqzPYNNPx4HSlavZs176SJbyDJazLHqbkejYt2yIxiq1/M9qp0MHOTioXyWfXb6I9sd
VxOHrYy/mLsD5nSZa425Oj1RUa9sEMCI3ZE2TlgYvXfqq9dtkRYw9afUtLPvfMlqnTsU42Iqcisn
fA96qm2+6LXZt1Tvdui9NvVjrcN/H1r1ZyugsxNmjVU23a5EVPmU+5n5aptbV87W+FrW6sjyyM7U
OHrZyhFStvmZHHcq3EWJUReevPHOxOqL0V0bUX3FXZUXqaIBg5ycVC+Sz67fRHtjO09h62DoS0qj
5nxyXLVxVlVFXnsTyTvToidEdI5E9xE3VV6ivh60GpbufY+ZbVynXpyMVU5EZA+d7FRNt91Ww/fq
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
f7lfOY2ktE6ho6b4QUbGPWrLp+k+HLck0e9Zzse+JdlR2z17VyJ5PN1693UAtcPxC0hl883CY/LL
LbkfJHA5aszIbD49+dsUzmJHK5qNcqoxzlRGr5lKk4Zwq4f3sC7TWFz2jtQWJsA5qR5d2rZpcbvH
G5jJ4qrrCq1zmrt2fYta3nVEXZDuYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB//Z

--MP_/m36g8KMQBxpMMIjZkVoJuET--
