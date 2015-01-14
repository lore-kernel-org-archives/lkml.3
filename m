Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbbANWuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:50:54 -0500
Received: from mail-bl2on0131.outbound.protection.outlook.com ([65.55.169.131]:57056
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754575AbbANWuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:50:51 -0500
X-WSS-ID: 0NI6VGL-07-E4Q-02
X-M-MSG: 
Message-ID: <54B6F2C4.20701@amd.com>
Date: Wed, 14 Jan 2015 16:50:44 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <a.p.zijlstra@chello.nl>, <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: question regarding -D flag in perf stat
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(53754006)(199003)(51914003)(189002)(92566002)(86362001)(77096005)(97736003)(36756003)(77156002)(47776003)(65806001)(62966003)(64706001)(33656002)(105586002)(106466001)(120886001)(23756003)(64126003)(68736005)(50466002)(87936001)(83506001)(46102003)(101416001)(50986999)(229853001)(54356999)(65816999)(107886001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB194;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:3;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BLUPR02MB194;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR02MB194;
X-Forefront-PRVS: 04569283F9
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2015 22:50:45.8043
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB194
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I had a question regarding the intention of the -D flag after looking at 
perf stat numbers of the following workload:

main(){

int a=5, b=6;

int i;

#pragma omp for schedule(dynamic)

for (i=0; i<10000000; i++){

b=b+a;

}

return 0;

}

_Stats without delay:_

# perf stat -e cycles,instructions,cpu-clock,task-clock ../../test/a.out

Performance counter stats for '../../test/a.out':

    203,581,363,567 cycles #    1.500 GHz

      7,563,983,198 instructions #    0.04  insns per cycle

      135721.617844 cpu-clock (msec)

      135721.600586 task-clock (msec) # *5.985 CPUs utilized*

       22.678577620 seconds time elapsed (run time)

_Stats with delay of 10 seconds:_

# perf stat -D 10000 -e cycles,instructions,cpu-clock,task-clock 
../../test/a.out

b=363264281

Performance counter stats for '../../test/a.out':

    112,134,813,161 cycles #    1.500 GHz

      4,461,136,761 instructions #    0.04  insns per cycle

       74757.386789 cpu-clock (msec)

       74757.317781 task-clock (msec) # *3.324 CPUs utilized*

22.490237094 seconds time elapsed**(run time)*(delay time is not 
excluded here)*

The issue is that CPU utilization is calculated as 
task-clock/total-runtime which in the case of no delay is fine.
But for the delay case, the total run time should exclude the delay 
time. Right?
(and as a consequence, utilization would be calculated exclusive of the 
delay time which would give us CPU utilization only for the period 
during which perf actually collects info)

Or is this the way -D flag is intended to work?

Thanks for the clarifications,
-Aravind.
