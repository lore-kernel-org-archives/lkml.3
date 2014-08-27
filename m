Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935751AbaH0UPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:15:41 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36825 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaH0UPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:15:39 -0400
From: Lina Iyer <lina.iyer@linaro.org>
To: khilman@linaro.org, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, Lina Iyer <lina.iyer@linaro.org>
Subject: [PATCH v3 0/4] PM QoS: per-cpu PM QoS support
Date: Wed, 27 Aug 2014 14:14:35 -0600
Message-Id: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:
[ http://marc.info/?l=linux-pm&m=140794570012619&w=2 ]
- Amend commit texts

This patchset enables drivers to set per-cpu PM QoS. PM QoS requests currently
apply to all cpus. However, drivers may be interested in only a few cpu(s) that
need to gaurantee the QoS requirement. The reason being, some requests may be
needed only to allow a quicker response to an IRQ, while requests may apply to
a certain cpu or a cluster of cpus, as dictated by an usecase. For example, in
ARM architectures, it may be benefical to set a QoS requirement to handle use
cases on big/Little cluster, while the other cluster can be in the deepest idle
state it can be.

An intended application of this feature could be the cpuidle governor. For
example, governor can now look at a CPU_DMA_LATENCY request only for that cpu
when deciding the allowable C-States. In a clustered environment, the governor
would look at the QoS request for a set of cpus before deciding the cluster's
low power mode.

With these requirements in mind, the patches do the following -

- Reorganize the PM QoS and dev-PM QoS frameworks to pass around data structures
rather than member variables. Do not want to pass plist around. It is much more
scalable, if we pass the pm_qos_request object rather than its member.

- Enhance PM QoS framework to support the per-cpu requests. This is done by
adding a per-cpu array for each constraint. This array holds the per-cpu QoS
value for each constraint. The intelligence behind the per-cpu is on the driver.
The framework just adds the request against the list held by the constraint
structure. Adding a request adds the request to the list of requests
against a constraint and also parses the array to see if this request superseeds
any existing QoS value for the cpus that this request has specified. The
workload of parsing the request is borne when updating the request.

- The driver that does an add request passes in the PM QoS request
  structure, can now pass in an additional request type that indicates if the
request is to be applied to all cores (default and existing behavior) or applies
to a subset of the cpus using a cpumask.

- To get the request value of a constraint back, you could use the
pm_qos_request() or its new cpu variants pm_qos_request_for_cpu() and
pm_qos_request_for_cpumask(). The _for_cpu() allows returns an s32 value without
locking.

- The next feature builds up on the per-cpu PM QoS feature to provide the
ability to allow a driver to tag a QoS request against an IRQ instead of a cpu.
Drivers may be concerned with an IRQ handling latency because of CPU low
power states, for example. When adding a request, they could specify the request
type to tag an IRQ and provide the IRQ numbers. When using tools like
irq-balancer, the IRQ affinity may jump from one cpu to another and in such a
case, the request needs to be modified correctly. irq/manage.c provides such
notification whenever the affinity changes. However, the current mechanism
allows for only one notification callback. 

	- Change to the smp_affinity_notifications. Modify the exisiting
	  mechanism of a single callback to support a list of requests. Drivers
	  can register for change notifications.

	- From PM QoS register for notification on behalf of a driver whenever
	  a request with IRQ is specified. When the notification arrives, modify
	  the cpu affinity of the QoS request to the cpus, that the IRQ is affine to.

- Remarks
I do not have the cpuidle governor changes here at this point. Also, there is
no change to userspace at this point, i.e, userspace cannot specify a QoS
request against a cpu or specify an IRQ to tag this request against.

Thanks,
Lina

Lina Iyer (4):
  QoS: Modify data structures and function arguments for scalability.
  QoS: Enhance framework to support per-cpu PM QoS request
  irq: Allow multiple clients to register for irq affinity notification
  QoS: Enable PM QoS requests to apply only on smp_affinity of an IRQ

 Documentation/power/pm_qos_interface.txt |  18 +++
 drivers/base/power/qos.c                 |  14 +--
 drivers/infiniband/hw/qib/qib_iba7322.c  |   4 +-
 include/linux/interrupt.h                |  12 +-
 include/linux/irqdesc.h                  |   6 +-
 include/linux/pm_qos.h                   |  25 +++-
 kernel/irq/irqdesc.c                     |   1 +
 kernel/irq/manage.c                      |  85 +++++++++-----
 kernel/power/qos.c                       | 191 ++++++++++++++++++++++++++++++-
 lib/cpu_rmap.c                           |   2 +-
 10 files changed, 305 insertions(+), 53 deletions(-)

-- 
1.9.1

