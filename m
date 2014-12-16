Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaLPTam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 14:30:42 -0500
Received: from mout.web.de ([212.227.17.11]:57584 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbaLPTak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 14:30:40 -0500
Message-ID: <5490885B.4030000@users.sourceforge.net>
Date: Tue, 16 Dec 2014 20:30:35 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: kernel-janitors@vger.kernel.org
CC: Coccinelle <cocci@systeme.lip6.fr>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Determination for the number of named function parameters (with
 SmPL)
References: <547C4D11.1050206@users.sourceforge.net>
In-Reply-To: <547C4D11.1050206@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:VRqkGkTfJFV3ZFapmg3qSd0pL6wRR7Ty7ob78ru/R+i88nxd0sa
 2a4Yz6zb2pMMNiSElQ9DiswDyIrWRyEMGqb1NQANw9xPuzX8bRpwUzm7Rww9HMzD6E1mcNc
 e5sVE4KQrTlTnqP5xnu3egeBnHLYBHXQ/Er1QA6CPdYPNAuxBLSOwD+6N5QB/cnpYwcj2FP
 /MqiqlbHd7FkzikZ4o7Ew==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Would you like to know how many named function parameters are used in the source files?

How do you think about to try the following semantic query approach out a bit more?

@initialize:python@
@@
import sys
import sqlalchemy
sys.stderr.write("\n".join( ("Using SQLAlchemy version:",
                             sqlalchemy.__version__) ))
sys.stderr.write("\n")
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import sessionmaker
engine = create_engine("sqlite:///:memory:", echo=False)
base = declarative_base()

class function(base):
   __tablename__ = "numbers"
   name = Column(String, primary_key=True)
   source_file = Column(String, primary_key=True)
   line = Column(Integer, primary_key=True)
   column = Column(Integer, primary_key=True)
   parameter_number = Column(Integer)
   
   def __repr__(self):
      return """<function(name='%s',
source_file='%s',
line='%s',
column='%s',
parameter_number='%s')>""" % (self.name,
                              self.source_file,
                              self.line,
                              self.column,
                              self.parameter_number)

configured_session = sessionmaker(bind=engine)
session = configured_session()
base.metadata.create_all(engine)

def store_number(fun, source, count):
    """Add an integer to an internal table."""
    for place in source:
       entry = function(name = fun,
                        source_file = place.file,
                        line = place.line,
                        column = int(place.column) + 1,
                        parameter_number = count)
       session.add(entry)

@counting_parameters@
identifier work;
parameter list[number] pl;
position pos;
type return_type;
@@
 return_type work@pos(pl)
 {
  ...
 }

@script:python collection@
fun << counting_parameters.work;
count << counting_parameters.number;
place << counting_parameters.pos;
@@
store_number(fun, place, count)

@finalize:python@
@@
session.commit()
from sqlalchemy import func
entries = session.query(func.count("*")).select_from(function).scalar()

if entries > 0:
   delimiter = "|"
   sys.stdout.write(delimiter.join( ("number", "incidence") ))
   sys.stdout.write("\r\n")
   for number, incidence in session.query(function.parameter_number,
                                          func.count("*")).group_by(function.parameter_number):
      sys.stdout.write(delimiter.join( (str(number), str(incidence)) ))
      sys.stdout.write("\r\n")
else:
   sys.stderr.write("No result for this analysis!\n")



elfring@Sonne:~/Projekte/Coccinelle/Probe> XX=$(date) && spatch.opt -timeout 12 -sp-file list_parameter_numbers2.cocci -dir /usr/src/linux-stable > list_parameter_numbers2.txt 2> list_parameter_numbers2-errors.txt ; YY=$(date) && echo "$XX * $YY"
Di 16. Dez 18:51:03 CET 2014 * Di 16. Dez 19:16:28 CET 2014
...
elfring@Sonne:~/Projekte/Coccinelle/Probe> cat list_parameter_numbers2.txt
number|incidence
0|46
1|161270
2|103405
3|55551
4|25947
5|9569
6|4907
7|1860
8|738
9|335
10|177
11|108
12|64
13|20
14|11
15|8
16|4
17|5
18|1
21|1
22|1


Do you find such an analysis result from the source files for Linux 3.18
(with the help of the software "Coccinelle 1.0.0-rc23") interesting
for further considerations?

Regards,
Markus
